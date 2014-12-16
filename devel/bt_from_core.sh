#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $(basename "$0") CORE_FILE"
    exit 1
fi

core_file="$1"

bin_file=$(file -- "$core_file" | sed "s/.*'\\([^']*\\)'.*/\1/g") # '

echo "=== $bin_file ========================"
# sed -n '/sweet/,$p' filename
#
# -n don't print lines by default
#
# /sweet/,$ is a restriction for the following command p, meaning 'only look from the first occurence of 'sweet' to '$' (the end of the file)
#
# p print

gdb --quiet "$bin_file" --core "$core_file" -ex bt -ex quit 2>&1 | sed -n '/^#0 /,$p'

echo "=== $bin_file ========================"
