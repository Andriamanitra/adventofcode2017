#!/bin/bash
# Note: can take a a minute or two to process the input file

# Can be used like ./9-1.sh '{{<!>},{<!>},{<!>},{<a>}}'
# or just process 9-input.txt by doing ./9-1.sh
if [ $# -gt 0 ]; then
    input=$1
else
    input=$(<9-input.txt)
fi

escapere="([^!]*)!.(.*)"
garbagere="([^<]*)<([^>]*)>(.*)"
while [[ $input =~ $escapere ]]; do
    input=${BASH_REMATCH[1]}${BASH_REMATCH[2]}
done
while [[ $input =~ $garbagere ]]; do
    input=${BASH_REMATCH[1]}${BASH_REMATCH[3]}
done

let score=0
let depth=0
for (( i=0; i<${#input}; i++ )); do
    if [ ${input:$i:1} == "{" ]; then
        let depth++
    elif [ ${input:$i:1} == "}" ] && [ $depth -gt 0 ]; then
        let score=score+depth
        let depth--
    fi
done
echo $score
