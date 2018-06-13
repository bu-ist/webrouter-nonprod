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

@test "router_limits: 900k file upload test (http)" {
  # create temp file of that size
  #
  tmp_file="/tmp/upload_test.$$"
  time dd if=/dev/zero of="$tmp_file" count=900 bs=1024
  #head -c "900000" /dev/zero | tr '\0' '\141' >"$tmp_file"

  # test the upload
  #
  #test_web http "$BUWEBHOST" "/nisdev/php5/antonk/aws-upload-test/wpoenoe2j03irf.php" -X POST -H "Content-Type: multipart/form-data" -F "data=@$tmp_file"
  test_web http "$BUWEBHOST" "/htbin/testup.pl" -X POST -H "Content-Type: multipart/form-data" -F "data=@$tmp_file"

  # remove the temp file prior to status checks
  #
  ls -lh "$tmp_file"
  rm "$tmp_file"

  #dump_web
  assert_status 100
  # This returns the status 100 prequel which messes up our simple parsing
  assert_contains OK
  #assert_content OK
  #assert_backend phpbin
}

@test "router_limits: 9M file upload test (http)" {
  # create temp file of that size
  #
  tmp_file="/tmp/upload_test.$$"
  time dd if=/dev/zero of="$tmp_file" count=9000 bs=1024
  #head -c "900000" /dev/zero | tr '\0' '\141' >"$tmp_file"

  # test the upload
  #
  #test_web http "$BUWEBHOST" "/nisdev/php5/antonk/aws-upload-test/wpoenoe2j03irf.php" -X POST -H "Content-Type: multipart/form-data" -F "data=@$tmp_file"
  test_web http "$BUWEBHOST" "/htbin/testup.pl" -X POST -H "Content-Type: multipart/form-data" -F "data=@$tmp_file"

  # remove the temp file prior to status checks
  #
  ls -lh "$tmp_file"
  rm "$tmp_file"

  #dump_web
  assert_status 100
  # This returns the status 100 prequel which messes up our simple parsing
  assert_contains OK
  #assert_content OK
  #assert_backend phpbin
}

@test "router_limits: 20M file upload test (http)" {
  #skip "SKIPPING for now as there is a timeout issue affecting larger file uploads"
  # create temp file of that size
  #
  tmp_file="/tmp/upload_test.$$"
  time dd if=/dev/zero of="$tmp_file" count=20000 bs=1024
  #head -c "900000" /dev/zero | tr '\0' '\141' >"$tmp_file"

  # test the upload
  #
  #test_web http "$BUWEBHOST" "/nisdev/php5/antonk/aws-upload-test/wpoenoe2j03irf.php" -X POST -H "Content-Type: multipart/form-data" -F "data=@$tmp_file"
  test_web http "$BUWEBHOST" "/htbin/testup.pl" -X POST -H "Content-Type: multipart/form-data" -F "data=@$tmp_file"

  # remove the temp file prior to status checks
  #
  ls -lh "$tmp_file"
  rm "$tmp_file"

  #dump_web
  assert_status 100
  # This returns the status 100 prequel which messes up our simple parsing
  assert_contains OK
  #assert_content OK
  #assert_backend phpbin
}

@test "router_limits: 50M file upload test (http)" {
  #skip "SKIPPING for now as there is a timeout issue affecting larger file uploads"
  # create temp file of that size
  #
  tmp_file="/tmp/upload_test.$$"
  time dd if=/dev/zero of="$tmp_file" count=50000 bs=1024
  #head -c "900000" /dev/zero | tr '\0' '\141' >"$tmp_file"

  # test the upload
  #
  #test_web http "$BUWEBHOST" "/nisdev/php5/antonk/aws-upload-test/wpoenoe2j03irf.php" -X POST -H "Content-Type: multipart/form-data" -F "data=@$tmp_file"
  test_web http "$BUWEBHOST" "/htbin/testup.pl" -X POST -H "Content-Type: multipart/form-data" -F "data=@$tmp_file"

  # remove the temp file prior to status checks
  #
  ls -lh "$tmp_file"
  rm "$tmp_file"

  #dump_web
  assert_status 100
  # This returns the status 100 prequel which messes up our simple parsing
  assert_contains OK
  #assert_content OK
  #assert_backend phpbin
}

@test "router_limits: 90M file upload test (http)" {
  #skip "SKIPPING for now as there is a timeout issue affecting larger file uploads"
  # create temp file of that size
  #
  tmp_file="/tmp/upload_test.$$"
  time dd if=/dev/zero of="$tmp_file" count=90000 bs=1024
  #head -c "900000" /dev/zero | tr '\0' '\141' >"$tmp_file"

  # test the upload
  #
  #test_web http "$BUWEBHOST" "/nisdev/php5/antonk/aws-upload-test/wpoenoe2j03irf.php" -X POST -H "Content-Type: multipart/form-data" -F "data=@$tmp_file"
  test_web http "$BUWEBHOST" "/htbin/testup.pl" -X POST -H "Content-Type: multipart/form-data" -F "data=@$tmp_file"

  # remove the temp file prior to status checks
  #
  ls -lh "$tmp_file"
  rm "$tmp_file"

  #dump_web
  assert_status 100
  # This returns the status 100 prequel which messes up our simple parsing
  assert_contains OK
  #assert_content OK
  #assert_backend phpbin
}

@test "router_limits: 110M file upload test should fail with 413 code (http)" {
  #skip "SKIPPING for now as there is a timeout issue affecting larger file uploads"
  # create temp file of that size
  #
  tmp_file="/tmp/upload_test.$$"
  time dd if=/dev/zero of="$tmp_file" count=110000 bs=1024
  #head -c "900000" /dev/zero | tr '\0' '\141' >"$tmp_file"

  # test the upload
  #
  #test_web http "$BUWEBHOST" "/nisdev/php5/antonk/aws-upload-test/wpoenoe2j03irf.php" -X POST -H "Content-Type: multipart/form-data" -F "data=@$tmp_file"
  test_web http "$BUWEBHOST" "/htbin/testup.pl" -X POST -H "Content-Type: multipart/form-data" -F "data=@$tmp_file"

  # remove the temp file prior to status checks
  #
  ls -lh "$tmp_file"
  rm "$tmp_file"

  #dump_web
  assert_status 100
  # This returns the status 100 prequel which messes up our simple parsing
  assert_contains "413 Request Entity Too Large"
  #assert_content OK
  #assert_backend phpbin
}
