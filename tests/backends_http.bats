#!/usr/bin/env bats

#declare -A web

load webtests

teardown () {
  cleanup_web
}

setup () {
  setup_web

  # ####
  # Get our source IP according to the internet
  #
  if [ "x$myip" = "x" ]; then
    myip=$(dig +short myip.opendns.com @resolver1.opendns.com)
  fi
  #host=www-devl.bu.edu
}

#setup () {
#  init_web
#}

@test "backendip-http-legacy" {
  test_web http "$BUWEBHOST" "/server/backend/legacy/htbin/ipcheck/$myip"
  assert_status 200
  assert_backend "legacy"
  assert_content "OK"

  #dump_web
}

@test "backendip-http-legacy" {
  test_web http "$BUWEBHOST" "/server/backend/legacy/htbin/ipcheck/$myip"
  assert_status 200
  assert_backend "legacy"
  assert_content "OK"

  #dump_web
}

@test "backendip-http-phpbin" {
  test_web http "$BUWEBHOST" "/server/backend/phpbin/htbin/ipcheck/$myip"
  assert_status 200
  assert_backend "phpbin"
  assert_content "OK"

  #dump_web
}

@test "backendip-http-dbin" {
  skip "TEST MANUALLY: ipcheck does not work with dbin server (/dbin/oittest)"
  test_web http "$BUWEBHOST" "/server/backend/dbin/htbin/ipcheck/$myip"
  assert_status 200
  assert_backend "dbin"
  assert_content "OK"

  #dump_web
}

@test "backendip-http-django" {
  skip "TEST MANUALLY: ipcheck does not work with django server"
  test_web http "$BUWEBHOST" "/server/backend/django/htbin/ipcheck/$myip"
  assert_status 200
  assert_backend "django"
  assert_content "OK"

  #dump_web
}

@test "backendip-http-wordpress" {
  skip "TEST MANUALLY: Wordpress does not yet have the ipcheck script"
  test_web http "$BUWEBHOST" "/server/backend/wordpress/htbin/ipcheck/$myip"
  assert_status 200
  assert_backend "wordpress"
  assert_content "OK"

  #dump_web
}

@test "backendip-http-wpassets" {
  skip "TEST MANUALLY: Wordpress does not yet have the ipcheck script"
  test_web http "$BUWEBHOST" "/server/backend/wpassets/htbin/ipcheck/$myip"
  assert_status 200
  assert_backend "wpassets"
  assert_content "OK"

  #dump_web
}

@test "backendip-http-content" {
  uri="/server/backend/content/cgi-bin/ipcheck/$myip"
  # prod is the sole remaining system with the old content server comment the below out when it switches
  if [ "x$LANDSCAPE" = "xprod" ]; then
    uri="/server/backend/content/htbin/ipcheck/$myip"
  fi
  test_web http "$BUWEBHOST" "$uri"
  assert_status 200
  #assert_backend "content"
  assert_content "OK"

  #dump_web
}

