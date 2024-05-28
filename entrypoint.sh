#!/usr/bin/env sh
# execute a script before the command
if [ -n "${BEFORE_SCRIPT}" ]; then
    exec "${BEFORE_SCRIPT}" || exit $?
fi
# execute the command
if [ -n "${*}" ]; then
    exec "$@"
    E=$?
else
    (>&2 echo "ERROR: Missing docker command!")
    E=1
fi
# execute the script after the command
if [ -n "${AFTER_SCRIPT}" ]; then
    exec "${AFTER_SCRIPT}" || exit $?
fi
# exit with the return code of the command
exit $E
