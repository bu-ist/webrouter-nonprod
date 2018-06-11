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

  webrouter_header_size="8192"
  #webrouter_header_size="7000"
  #webrouter_header_size="4096"
  #webrouter_header_size="2048"
  #webrouter_header_size="1024"
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

@test "router_limits: max output header = 2k from upstream (http)" {
  #skip "TEST MANUALLY: enable Query Monitor on the hub site"
  # http://www.bu.edu/nisdev/php5/antonk/aws-header-size-test/p9ijp3oifnp.php/?size=1000
  #set -x
  test_web http "$BUWEBHOST" "/nisdev/php5/antonk/aws-header-size-test/p9ijp3oifnp.php/?size=2048"
  assert_status 200
  assert_backend "phpbin"
  assert_header_contains set_cookie "00_XYZ"
  assert_contains "OK"

}

@test "router_limits: max output header = 4k from upstream (http)" {
  #skip "TEST MANUALLY: enable Query Monitor on the hub site"
  # http://www.bu.edu/nisdev/php5/antonk/aws-header-size-test/p9ijp3oifnp.php/?size=1000
  #set -x
  test_web http "$BUWEBHOST" "/nisdev/php5/antonk/aws-header-size-test/p9ijp3oifnp.php/?size=4096"
  assert_status 200
  assert_backend "phpbin"
  assert_header_contains set_cookie "00_XYZ"
  assert_contains "OK"

}

@test "router_limits: max output header = 7.9k from upstream (http)" {
  #skip "TEST MANUALLY: enable Query Monitor on the hub site"
  # http://www.bu.edu/nisdev/php5/antonk/aws-header-size-test/p9ijp3oifnp.php/?size=7900"
  #set -x
  test_web http "$BUWEBHOST" "/nisdev/php5/antonk/aws-header-size-test/p9ijp3oifnp.php/?size=7900"
  assert_status 200
  assert_backend "phpbin"
  assert_header_contains set_cookie "00_XYZ"
  assert_contains "OK"

}

@test "router_limits: max output header = 8.9k from upstream does not crash (it could truncate)" {
  #skip "TEST MANUALLY: enable Query Monitor on the hub site"
  # http://www.bu.edu/nisdev/php5/antonk/aws-header-size-test/p9ijp3oifnp.php/?size=7900"
  #set -x
  test_web http "$BUWEBHOST" "/nisdev/php5/antonk/aws-header-size-test/p9ijp3oifnp.php/?size=7900"
  assert_status 200
  assert_backend "phpbin"
  assert_contains "OK"

}

