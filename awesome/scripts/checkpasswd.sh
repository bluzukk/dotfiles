#!/bin/bash
username=$1

# IFS=<space> - set IFS to an empty string (no character will be used to split,
#   therefore no splitting will occur)
#   so that read will read the entire line
#   and see it as one word that will be assigned to the line variable
# -r - do not allow backslashes to escape any characters
# -s - do not echo input coming from a terminal
# -p - output the string PROMPT without a trailing newline before attempting to read

# Test that the given password is correct by trying to run a command using it
echo $2 | /bin/su -f --command true - $1;
retval=$?;

if [ $retval -eq 0 ]; then
    echo "Yay - the password is valid!";
else
    echo "Password is not valid";
fi

