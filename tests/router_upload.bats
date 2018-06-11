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

  upload_test_size=95000000
  #
  webrouter_header_size="8000"
  #webrouter_header_size="7000"
  #webrouter_header_size="4096"
  #webrouter_header_size="2048"
  #webrouter_header_size="1024"
}

@test "router_limits: 9M file upload test (http)" {
  # create temp file of that size
  #
  tmp_file="/tmp/upload_test.$$"
  head -c "9000000" /dev/zero | tr '\0' '\141' >"$tmp_file"

  # test the upload
  #
  test_web http "$BUWEBHOST" "/nisdev/php5/antonk/aws-upload-test/wpoenoe2j03irf.php" -X POST -H "Content-Type: multipart/form-data" -F "data=@$tmp_file"

  # remove the temp file prior to status checks
  #
  ls -lh "$tmp_file"
  rm "$tmp_file"

  assert_status 100
  assert_backend phpbin
}

@test "router_limits: 20M file upload test (http)" {
  # create temp file of that size
  #
  tmp_file="/tmp/upload_test.$$"
  head -c "20000000" /dev/zero | tr '\0' '\141' >"$tmp_file"

  # test the upload
  #
  test_web http "$BUWEBHOST" "/nisdev/php5/antonk/aws-upload-test/wpoenoe2j03irf.php" -X POST -H "Content-Type: multipart/form-data" -F "data=@$tmp_file"

  # remove the temp file prior to status checks
  #
  ls -lh "$tmp_file"
  rm "$tmp_file"

  assert_status 100
  assert_backend phpbin
}

