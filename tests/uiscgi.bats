#!/usr/bin/env bats

load webtests

teardown () {
  cleanup_web
}

setup () {
  setup_web
  backend_prefix=uiscgi
  if [ "x$LANDSCAPE" = "xbuwd" ]; then
    backend_prefix=buwd_uiscgi
  fi
}

#setup () {
#  init_web
#}

@test "Add trailing slash to /link" {
  test_web http "$BUWEBHOST" /link
  assert_status 301
  assert_header location "http://$BUWEBHOST/link/"
  assert_backend "${backend_prefix}_content"
}

@test "Redirect /link/ to UISCGI" {
  test_web https "$BUWEBHOST" /link/
  assert_status 302
  assert_header location "https://$BUWEBHOST/link/bin/uiscgi.pl/uismpl/menu"
  assert_backend "${backend_prefix}_content"
}

# this will eventually redirect to SSL
@test "UISCGI non-ssl main menu" {
  test_web http "$BUWEBHOST" /link/bin/uiscgi.pl/uismpl/menu
  assert_status 200
  assert_contains "/link/system/images/bu-logo.gif"
  assert_backend "${backend_prefix}_app"
}

@test "UISCGI ssl main menu shows the main menu" {
  test_web https "$BUWEBHOST" /link/bin/uiscgi.pl/uismpl/menu
  assert_status 200
  assert_contains "/link/system/images/bu-logo.gif"
  assert_backend "${backend_prefix}_app"
}

@test "Test that UISCGI outputs cache control header" {
  test_web http "$BUWEBHOST" /link/bin/args.pl
  assert_status 200
  assert_backend "${backend_prefix}_app"
  echo "*******"
  echo "This will fail with the old Solaris servers so do not be surprised"
  echo "*******"
  assert_header cache_control "no-cache, no-store"
}

@test "Studentlink redirect" {
  test_web http "$BUWEBHOST" /studentlink/
  assert_status 302
  assert_header location "http://$BUWEBHOST/link/bin/uiscgi_studentlink.pl/uismpl/?ModuleName=menu.pl&NewMenu=Home"
}

@test "StudentLink main menu and mainframe CUSSP call" {
  test_web http "$BUWEBHOST" '/link/bin/uiscgi_studentlink.pl/1486741068?ModuleName=univschr.pl&SearchOptionDesc=Distance+Education&SearchOptionCd=D&KeySem=20183&ViewSem=Fall+2017'
  assert_status 200
  assert_backend "${backend_prefix}_app"
  assert_contains '<TH>Search by:</TH>'
}

