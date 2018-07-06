import "bb/stacktrace.sh"

# (String, 'a', ':', String, 'b', ':', Function): Number?
#
#     assert.eql 'some assertion' \
#       a = "expected value" \
#       b = some command that outputs the actual value
#
#     assert.eql 'it creates the user with the correct name' \
#       a = 'my-user' \
#       b = useradd my-user
#
assert.eql() {
  local msg="$1"
  shift 1 # message

  shift 2 # a =
  local expected="$1"
  shift 1 # $expected

  shift 2 # b =

  local actual="$( "$@" )"
  local exitcode=$?

  if [[ " ${actual} " != " ${expected} " || $exitcode -ne 0 ]]; then
    printf "${TTY_RED}${msg}${TTY_RESET}\n" 1>&2
    printf "expected \"${actual}\" to equal \"${expected}\"" 1>&2
    printf "\n" 1>&2

    stacktrace.track
    stacktrace.print

    exit 1
  fi

  printf "${TTY_TICK} ${msg}\n"
}

assert.ok() {
  local msg="$1"
  shift 1

  ( "$@" ) 2>&1 1>/dev/null

  local exitcode=$?

  test $exitcode -eq 0 || {
    printf "${TTY_RED}${msg}${TTY_RESET}\n" 1>&2
    printf "expected command to succeed but instead exited with $exitcode" 1>&2
    printf "\n" 1>&2

    stacktrace.track
    stacktrace.print

    exit 1
  }

  printf "${TTY_TICK} ${msg}\n"
}
