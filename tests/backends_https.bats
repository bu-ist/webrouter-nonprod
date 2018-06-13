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
  myip=$(dig +short myip.opendns.com @resolver1.opendns.com)
  #host=www-devl.bu.edu
}

#setup () {
#  init_web
#}

@test "backendip-https-legacy" {
  test_web https "$BUWEBHOST" "/server/backend/legacy/htbin/ipcheck/$myip"
  assert_status 200
  assert_backend "legacy"
  assert_content "OK"

  #dump_web
}

@test "backendip-https-phpbin" {
  test_web https "$BUWEBHOST" "/server/backend/phpbin/htbin/ipcheck/$myip"
  assert_status 200
  assert_backend "phpbin"
  assert_content "OK"

  #dump_web
}

@test "backendip-https-dbin" {
  skip "TEST MANUALLY: ipcheck does not work with dbin server (/dbin/oittest)"
  test_web https "$BUWEBHOST" "/server/backend/dbin/htbin/ipcheck/$myip"
  assert_status 200
  assert_backend "dbin"
  assert_content "OK"

  #dump_web
}

@test "backendip-https-django" {
  skip "TEST MANUALLY: ipcheck does not work with django server"
  test_web https "$BUWEBHOST" "/server/backend/django/htbin/ipcheck/$myip"
  assert_status 200
  assert_backend "django"
  assert_content "OK"

  #dump_web
}

@test "backendip-https-wordpress" {
  skip "TEST MANUALLY: Wordpress does not yet have the ipcheck script"
  test_web https "$BUWEBHOST" "/server/backend/wordpress/htbin/ipcheck/$myip"
  assert_status 200
  assert_backend "wordpress"
  assert_content "OK"

  #dump_web
}

@test "backendip-https-wpassets" {
  skip "TEST MANUALLY: Wordpress does not yet have the ipcheck script"
  test_web https "$BUWEBHOST" "/server/backend/wpassets/htbin/ipcheck/$myip"
  assert_status 200
  assert_backend "wpassets"
  assert_content "OK"

  #dump_web
}

@test "backendip-https-content" {
  uri="/server/backend/content/cgi-bin/ipcheck/$myip"
  # prod is the sole remaining system with the old content server comment the below out when it switches
  if [ "x$LANDSCAPE" = "xprod" ]; then
    uri="/server/backend/content/htbin/ipcheck/$myip"
  fi
  test_web https "$BUWEBHOST" "$uri"
  assert_status 200
  #assert_backend "content"
  assert_content "OK"

  #dump_web
}

