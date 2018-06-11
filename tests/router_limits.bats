#!/usr/bin/env bats
#
# These checks make certain that the web router handles the correct inputs
# 

load webtests

teardown () {
  cleanup_web
}

setup () {
  setup_web
}

@test "router_limits: max file upload size (http)" {
  skip "TEST MANUALLY: http://www.bu.edu/peaclab/wp-admin/async-upload.php"
}

@test "router_limits: max file upload size (https)" {
  skip "TEST MANUALLY: https://www.bu.edu/peaclab/wp-admin/async-upload.php"
  test_web https "$BUWEBHOST" /server/healthcheck
  assert_status 200
  assert_backend healthcheck
  assert_contains OK
}

@test "router_limits: max output header from upstream (http)" {
  skip "TEST MANUALLY: enable Query Monitor on the hub site"
  test_web http "$BUWEBHOST" "/server/backend/uiscgi_app/server/healthcheck"
  assert_status 200
  assert_backend "uiscgi_app"
  assert_contains "OK"
}

@test "router_limits: max output header from upstream (https)" {
  skip "TEST MANUALLY: enable Query Monitor on the hub site"
  test_web http "$BUWEBHOST" "/server/backend/uiscgi_app/server/healthcheck"
  assert_status 200
  assert_backend "uiscgi_app"
  assert_contains "OK"
}
