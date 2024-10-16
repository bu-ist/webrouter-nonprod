#!/bin/sh 
# 
# Simple script to use curl to test an app node prior to switching over
#
echo start_execution


mv ubuntu_home.log ubuntu_home.save.log
rm ubuntu_home.log

localmachine="ubuntu_home"
LOGFILE=${localmachine}.log
echo ">> Start --<<" >>${LOGFILE}
date >>${LOGFILE}
w >>${LOGFILE}

export http_proxy
http_proxy=
export https_proxy
https_proxy=

julog=/bin/false
do_upstream=/bin/true
exitcode=0


cat /dev/null

host=www-devl.bu.edu

test_log () {
  label="$1"
  shift
  status="$1"
  shift
  log="$1"

  if $julog ; then
    if juLog -name="$label" "$status" "$log" ; then
      /bin/true
    else
      exitcode=1
    fi
  else
    if "$status" ; then
      echo "PASS $label $log"
    else
      echo "FAIL $label $log"
      exitcode=1
    fi
  fi
}

# test_url label url host retcode upstream strings...
#
test_url () {

  if [ "x$1" = "x--head" ]; then
    CURL_ARGS="-Is"
    shift
  else
    CURL_ARGS="-is"
  fi
  if [ "x$1" = "x--referer" ]; then 
    shift
    CURL_ARGS="$CURL_ARGS -H 'Referer:$1'"
    shift
  fi
  label="$1"
  shift
  url="$1"
  shift
  #host="$1"
  #shift
  retcode="$1"
  shift
  upstream="$1"
  shift

  # if we have a global limit then see if this 
  skip=/bin/false
  if [ "x$limit" != "xall" ]; then
    if echo "$label" | grep -q -v "$limit" ; then
      skip=/bin/true
    fi
  fi
  if $skip ; then
    return
  fi

  tmp_file="$PWD/test_url.$$"

  # ####
  # first, try the URL storing the output in a file
  # want -k option so SSL cert will work
  #
  if $verbose ; then
    echo "curl $CURL_ARGS -k -H Host:$HOST $url"
  fi
  if curl $CURL_ARGS -k -o "$tmp_file" -H "Host:$HOST" "$url" ; then
    # worked so do our tests
    # on sucessful runs we only want to print one line for both upstream and return code
    pass_ret_and_upstream=/bin/true
    # return code:
    t_retcode=$(head -1 "$tmp_file" | awk '{print $2}' )
    if [ "x$t_retcode" = "x$retcode" ]; then
      /bin/true; #echo "PASS $url retcode=$retcode"
    else
      test_log "$label" /bin/false "retcode=$t_retcode instead of $retcode"
      pass_ret_and_upstream=/bin/false
    fi

    # look for the upstream provider field
    if $do_upstream ; then
      t_upstream=$(grep '^X-Upstream: ' "$tmp_file" | tr -d '\r' | awk '{print $2}' )
      #echo "upstream=$upstream t_upstream=$t_upstream"
      if [ "x$t_upstream" = "x$upstream" ] ; then
        /bin/true; #echo "PASS $label upstream=$upstream"
      else
        test_log "$label" /bin/false "upstream=$t_upstream instead of $upstream"
        pass_ret_and_upstream=/bin/false
      fi
    else
      upstream="(skipped)"
    fi

    if $pass_ret_and_upstream ; then
      test_log "$label" /bin/true "retcode=$retcode upstream=$upstream"
    fi
 
    # now regexp to be found in the output
    for regexp in "$@" ; do
      if grep -q "$regexp" "$tmp_file" ; then
        test_log "$label" /bin/true "regexp ($regexp) found"
      else
        test_log "$label" /bin/false "regexp ($regexp) NOT found"
      fi 
    done 
  else
    # error occured
    test_log "$label" /bin/false "**** could not access URL"
  fi

  if [ -f "$tmp_file" ]; then
    if $debug ; then
      cat "$tmp_file"
    fi
    rm "$tmp_file"
  fi 
}

limit="all"
if [ "x$1" = "x-S" ]; then
  do_upstream=/bin/false
  shift
fi
if [ "x$1" = "x-j" ]; then
  source /sh2ju.sh
  juLogClean
  julog=/bin/true
  shift
fi
if [ "x$1" = "x-t" ]; then
  shift
  limit="$1"
  shift
fi
debug=/bin/false
if [ "x$1" = "x-d" ]; then 
  debug=/bin/true
  shift
fi
verbose=/bin/false
if [ "x$1" = "x-v" ]; then 
  verbose=/bin/true
  shift
fi
# now determine landscape and hostname from role and landscape in hostname
# From the 3rd part of the host name, obtain host role (e.g., "content" or "app"):
# where host name is like "ist-uiscgi-app-syst01", where role is "app".
#system_host=`/bin/hostname`
#ROLE=`echo $system_host | /bin/sed -n -e 's/^[^-]*-[^-]*-\([^-]*\)-.*$/\1/p'`;
#LANDSCAPE=`echo $system_host | /bin/sed -n -e 's/.*[^-][^-]*-\([A-Za-z][A-Za-z]*\)[0-9][0-9][.]*.*$/\1/p'`;

#if [ "x$ROLE" = "xapppci" ]; then
#  PREFIX="wwws"
#else
#  PREFIX="www"
#fi
LANDSCAPE="$1"
if [ "x$LANDSCAPE" = x ]; then
  echo "$0 landscape [host]"
  echo "landscape=syst,devl,buwd,qa,test,prod"
  exit
fi
# if we have another parameter that will be the hostname to use on the requests
CONNECT_TO="localhost"
if [ "x$2" != "x" ]; then
  CONNECT_TO="$2"
fi

if [ "$LANDSCAPE" = "prod" ]; then
  HOST="www.bu.edu"
else
  HOST="www-$LANDSCAPE.bu.edu"
fi

if $julog ; then
  /wait-for-it.sh -t 60 "$CONNECT_TO:80"
fi

echo "Starting test series Wordpress"
echo "### Test default routing to WordPress" >>${LOGFILE}
echo ">> Start Wordpress --<<" >>${LOGFILE}
test_url "default-wpapp-http-admissions" http://${CONNECT_TO}/admissions/ 200 wpapp >>${LOGFILE}
test_url "default-wpapp-https-admissions" https://${CONNECT_TO}/admissions/ 200 wpapp >>${LOGFILE}
test_url --head  "default-wpassets-http-admissions" http://${CONNECT_TO}/admissions/files/2012/09/footbar_visit.png 200 wpassets >>${LOGFILE}
test_url "default-wpapp-http-admissions" http://${CONNECT_TO}/admissions/visit-us/schedule-your-visit/ 200 wpapp >>${LOGFILE}

echo "Starting test series UISCGI"
echo "### Test routing to UISCGI" >>${LOGFILE}
test_url "uiscgi-http-link-trailing-slash" http://${CONNECT_TO}/link 301 uiscgi_content "Location: http://$HOST/link/" >>${LOGFILE}
test_url "uiscgi-http-link-to-uiscgi" http://${CONNECT_TO}/link/ 302 uiscgi_content "Location: http://$HOST/link/bin/uiscgi.pl/uismpl/menu" >>${LOGFILE}
test_url "uiscgi-http-link-menu" http://${CONNECT_TO}/link/bin/uiscgi.pl/uismpl/menu 200 uiscgi_app "/link/system/images/bu-logo.gif" >>${LOGFILE}
# next test commented out until test backend handles SSL TODO:
#test_url "uiscgi-https-link-menu" https://${CONNECT_TO}/link/bin/uiscgi.pl/uismpl/ menu 200 uiscgi_app "/link/system/images/bu-logo.gif >>${LOGFILE}
test_url "uiscgi-http-link-args" http://${CONNECT_TO}/link/bin/args.pl 200 uiscgi_app "Cache-Control: no-cache" >>${LOGFILE}
# next test commented out until test backend handles SSL TODO:
#test_url "uiscgi-https-link-args" https://${CONNECT_TO}/link/bin/args.pl 200 uiscgi_app "Cache-Control: no-cache" >>${LOGFILE}
#test_url https://localhost/link/bin/uiscgi.pl  200 uiscgi "/link/system/images/bu-logo.gif" >>${LOGFILE}

# test mainframe CUSSP call
echo "Starting test series LINK"
echo "### Test studentlink and mainframe CUSSP call" >>${LOGFILE} 
test_url "uiscgi-http-studentlink-redirect" "http://${CONNECT_TO}/studentlink/" 302 redirect "Location: http://$HOST/link/bin/uiscgi_studentlink.pl/uismpl/?ModuleName=menu.pl&NewMenu=Home" >>${LOGFILE}
test_url "uiscgi-http-studentlink-menu" "http://${CONNECT_TO}/link/bin/uiscgi_studentlink.pl/1486741068?ModuleName=univschr.pl&SearchOptionDesc=Distance+Education&SearchOptionCd=D&KeySem=20183&ViewSem=Fall+2017" 200 uiscgi_app '<TH>Search by:</TH>' >>${LOGFILE}

echo "Starting test series PHP"
echo "### Test PHP services" >>${LOGFILE}
test_url "dbin-http-oittest" http://${CONNECT_TO}/dbin/oittest/info.php 200 dbin '<h2>PHP License</h2>' >>${LOGFILE}
test_url "phpbin-http-buniverse" http://${CONNECT_TO}/buniverse/ 200 phpbin buniverse >>${LOGFILE}
test_url "phpbin-http-maps" http://${CONNECT_TO}/maps/ 200 phpbin 'var BUMapsVersion = 1' >>${LOGFILE}
#test_url "phpbin-http-mapslivebus-new" http://${CONNECT_TO}/maps/livebus/ 200 phpbin buniverse >>${LOGFILE}

echo "Starting test series Robots.txt"
echo "### Test Robots.txt services" >>${LOGFILE}
if [ "$LANDSCAPE" = "prod" ]; then
  test_url "robots-http-prod" "http://${CONNECT_TO}/robots.txt" 200 content 'default action - currently it allows access to most of the site' >>${LOGFILE}
else
  test_url "robots-http-non-prod" "http://${CONNECT_TO}/robots.txt" 200 content 'disallows all robots on test and development servers' >>${LOGFILE}
fi
test_url "homepage-http-content" "http://${CONNECT_TO}/" 200 content '<!-- HPPUBDDATE' >>${LOGFILE}

if false ; then
echo ""
echo "Testing redirects"
echo "### Test PHP services" >>${LOGFILE}
test_url "redirect-http-law-foo" "http://${CONNECT_TO}/LAW/foo" 301 redirect 'Location: http://www.bu.edu/law/foo' >>${LOGFILE}
test_url "redirect-http-law-foo" "http://${CONNECT_TO}/LAW" 301 redirect 'Location: http://www.bu.edu/law' >>${LOGFILE}
test_url "redirect-http-law-foo" "http://${CONNECT_TO}/LAW/foo/bar" 301 redirect 'Location: http://www.bu.edu/law/foo/bar' >>${LOGFILE}
fi

#echo "" 
#echo "Testing system urls"
#test_url "server-http-version" "http://${CONNECT_TO}/server/version" 200 version 'hostname: '
#test_url "server-http-cloudfrontips" "http://${CONNECT_TO}/server/cloudfront_ips" 200 cloudfront_ips
test_url "http-students" "http://${CONNECT_TO}/students/" 200 wpapp 'generated in' >>${LOGFILE}

test_url "http-degree-advice-root" "http://${CONNECT_TO}/degree-advice/" 301 degree-advice "http://$HOST/degree-advice/IRISLink.cgi" >>${LOGFILE}
test_url "http-degree-advice-cgi" "http://${CONNECT_TO}/degree-advice/IRISLink.cgi" 302 degree-advice "idp/profile/SAML2/Redirect/SSO" >>${LOGFILE}
test_url "https-degree-advice-cgi" "https://${CONNECT_TO}/degree-advice/IRISLink.cgi" 302 degree-advice "idp/profile/SAML2/Redirect/SSO" >>${LOGFILE}

test_url "http-healthcheck" "http://${CONNECT_TO}/server/healthcheck" 200  healthcheck OK >>${LOGFILE}
test_url "https-healthcheck" "https://${CONNECT_TO}/server/healthcheck" 200  healthcheck OK >>${LOGFILE}

echo ">> Completed 

<<" >>${LOGFILE}
date >>${LOGFILE}

echo completed
exit $exitcode

