#!/usr/bin/env bash

maxlevel=4
lines=5

used () {
    local level=$1
    local dir="$2"

    #echo "top $lines"
    if [[ -n "${dir}" ]]; then
        cd "$dir"
    fi
    
    while read -r size name
    do
        #echo "start $level $dir at $PWD"
        if (( level >= maxlevel ))
        then
            continue
        fi
        for (( i=1; i<level; i++)); do echo -en "\t"; done
        echo "${size} MB - $name"
        if [ -d "$name" ]; then
            (( level++ ))
            used $level "$name"
            (( level-- ))
            cd ..
        fi
    done < <(du -xms * 2> /dev/null|sort -nr|head -${lines})
}

cd /
used 1
