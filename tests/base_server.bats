#!/usr/bin/env bats
# These checks check internal behavior
# 

load webtests

teardown () {
  cleanup_web
}

setup () {
  setup_web
}

@test "base_server: Healthcheck (http)" {
  test_web http "$BUWEBHOST" /server/healthcheck
  assert_status 200
  assert_backend healthcheck
  assert_contains OK
}

@test "base_server: Healthcheck (https)" {
  test_web https "$BUWEBHOST" /server/healthcheck
  assert_status 200
  assert_backend healthcheck
  assert_contains OK
}

@test "base_server: backend test (http)" {
  test_web http "$BUWEBHOST" "/server/backend/uiscgi_app/server/healthcheck"
  assert_status 200
  assert_backend "uiscgi_app"
  assert_contains "OK"
}

