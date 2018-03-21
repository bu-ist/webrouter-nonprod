#!/usr/bin/env bats

#declare -A web

load webtests

teardown () {
  cleanup_web
}

setup () {
  setup_web
  #host=www-devl.bu.edu
}

#setup () {
#  init_web
#}

@test "wpapp-http-admissions" {
  test_web http "$BUWEBHOST" /admissions/ 
  assert_status 200
  assert_backend "wordpress"

  return
  dump_headers
  return 
  dump_web
  assert_header x_bu_backend "wordpress"
}

@test "wpapp-https-admissions" {
  test_web https "$BUWEBHOST" /admissions/ 
  assert_status 200
  assert_backend "wordpress"
}

@test "WordPress asset servers" {
  skip_landscapes syst
  test_web http "$BUWEBHOST" /admissions/files/2012/09/footbar_visit.png
  assert_status 200
  assert_backend "wpassets"
}

@test "WordPress admissions schedule your page" {
  skip_landscapes syst
  test_web http "$BUWEBHOST" /admissions/visit-us/schedule-your-visit/
  assert_status 200
  assert_backend "wordpress"
}

#@test "Weblogin login CGI script" {
#  test_web http "$BUWEBHOST" /htbin/login
#  assert_backend "legacy"
#  assert_redirect_to_weblogin 
#}

#@test "Web 3270 weblogin authentication" {
#  test_web http "$BUWEBHOST" /uis_web3270/
#  # for some reason the prod version does not do Weblogin
#  if [ "$LANDSCAPE" = prod ]; then
#    assert_status 200
#    assert_contains "HOD WIZARD HTML"
#    assert_header server "IBM_HTTP_Server"
#    assert_backend "legacy"
#  else
#    assert_redirect_to_weblogin 
#  fi
#}

#@test "Simple dbin test" {
#  test_web http "$BUWEBHOST" /dbin/oittest/
#  assert_status 200
#  assert_backend "dbin"
#  assert_contains '<h2>Done</h2>'
#}

@test "Maps uses phpbin even though it is not in /phpbin" {
  skip_landscapes syst
  test_web http "$BUWEBHOST" /maps/
  assert_status 200
  assert_backend "phpbin"
  assert_contains 'var BUMapsVersion = 1'
}

@test "BUuniverse uses phpbin even though it is not in /phpbin" {
  skip_landscapes syst
  test_web http "$BUWEBHOST" /buniverse/
  assert_status 200
  assert_backend "phpbin"
  assert_contains "buniverse"
}

#@test "Cellphone Compliance django app (http)" {
#  skip_landscapes syst
#  test_web http "$BUWEBHOST" /cellphone-compliance/
#  assert_status 302
#  assert_header location "http://$BUWEBHOST/cellphone-compliance/accounts/login/?next=/cellphone-compliance/"
#  assert_backend "django"
#}

#@test "Cellphone Compliance django app (https)" {
#  skip_landscapes syst
#  test_web https "$BUWEBHOST" /cellphone-compliance/
#  assert_status 302
#  assert_header location "https://$BUWEBHOST/cellphone-compliance/accounts/login/?next=/cellphone-compliance/"
#  assert_backend "django"
#}

@test "Courseware Manager admin" {
  skip_landscapes syst
  test_web http "$BUWEBHOST" /courseware-manager/admin/
  assert_status 302
  assert_header_contains location "http://$BUWEBHOST/courseware-manager/admin/login/"
  assert_backend "django"
}

@test "DNA mixtures" {
  skip_landscapes syst
  test_web http "$BUWEBHOST" /dnamixtures/
  assert_status 200
  assert_backend "django"
  assert_contains "/dnamixtures/static/dna_lessons"
}

@test "Robots.txt" {
  test_web http "$BUWEBHOST" /robots.txt
  assert_status 200
  # eventually it should be 
  #assert_backend "content"
  # right now it can be one of two values - legacy for Solaris servers and content for all others
  assert_backend content legacy

  if [ "$LANDSCAPE" = "prod" ]; then
    assert_contains 'default action - currently it allows access to most of the site'
  else
    assert_contains 'disallows all robots on test and development servers'
  fi
}

@test "Homepage" {
  test_web http "$BUWEBHOST" /
  assert_status 200
  # eventually it should be 
  #assert_backend "content"
  # right now it can be one of two values - legacy for Solaris servers and content for all others
  assert_backend content legacy

  assert_contains '<!-- HPPUBDDATE'
}

@test "Students WordPress site" {
  skip_landscapes syst
  test_web http "$BUWEBHOST" /students/
  assert_status 200
  assert_backend wordpress
  assert_contains 'generated in'
}

@test "Degree-Advice root (http)" {
  skip_landscapes syst
  test_web http "$BUWEBHOST" /degree-advice/
  assert_status 301
  assert_backend degree-advice
  assert_header_contains location "http://${BUWEBHOST}/degree-advice/IRISLink.cgi"
}

#@test "Degree-Advice root (https)" {
#  skip_landscapes syst
#  test_web https "$BUWEBHOST" /degree-advice/
#  assert_status 301
#  assert_backend degree-advice
#  assert_header_contains location "http://${BUWEBHOST}/degree-advice/IRISLink.cgi"
#}

@test "Degree-Advice cgi (http)" {
  skip_landscapes syst
  test_web http "$BUWEBHOST" /degree-advice/IRISLink.cgi
  assert_status 302
  assert_backend degree-advice
  assert_header_contains location "/idp/profile/SAML2/Redirect/SSO"
}

@test "Degree-Advice cgi (https)" {
  skip_landscapes syst
  test_web https "$BUWEBHOST" /degree-advice/IRISLink.cgi
  assert_status 302
  assert_backend degree-advice
  assert_header_contains location "/idp/profile/SAML2/Redirect/SSO"
}


