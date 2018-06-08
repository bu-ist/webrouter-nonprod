#!/usr/bin/env bats

#declare -A web

load webtests

teardown () {
  cleanup_web
}

setup () {
  setup_web

}

#setup () {
#  init_web
#}

@test "basicauth-http-test" {
  test_web http "$BUWEBHOST" "/test/basic/" -u adam:adam
  assert_status 200
  assert_backend "content"
  assert_content "hello ground"

  #dump_web
}

@test "basicauth-https-test" {
  test_web https "$BUWEBHOST" "/test/basic/" -u adam:adam
  assert_status 200
  assert_backend "content"
  assert_content "hello ground"

  #dump_web
}

