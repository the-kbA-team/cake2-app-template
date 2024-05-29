#!/usr/bin/env sh
# execute a script before the command
if [ -n "${BEFORE_SCRIPT}" ]; then
    "${BEFORE_SCRIPT}" || exit $?
fi
# execute the command
if [ -n "${*}" ]; then
    /bin/sh -c "$*"
    E=$?
else
    (>&2 echo "ERROR: Missing docker command!")
    E=1
fi
# execute the script after the command
if [ -n "${AFTER_SCRIPT}" ]; then
    "${AFTER_SCRIPT}" || exit $?
fi
# exit with the return code of the command
exit $E
