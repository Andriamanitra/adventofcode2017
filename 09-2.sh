#!/bin/bash
# Note: can take a a minute or two to process the input file

# Can be used like ./9-2.sh '<{o"i!a,<{i<a>'
# or just process 9-input.txt by doing ./9-2.sh
if [ $# -gt 0 ]; then
    input=$1
else
    input=$(<9-input.txt)
fi

escapere="([^!]*)!.(.*)"
garbagere="([^<]*)<([^>]*)>(.*)"
let removed=0
while [[ $input =~ $escapere ]]; do
    input=${BASH_REMATCH[1]}${BASH_REMATCH[2]}
done
while [[ $input =~ $garbagere ]]; do
    let removed=removed+${#BASH_REMATCH[2]}
    input=${BASH_REMATCH[1]}${BASH_REMATCH[3]}
done

echo "Removed $removed characters of garbage."
