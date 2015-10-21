#!/bin/bash

COLUMNS=$(tput cols)
LINES=$(tput lines)
echo "Window: ${COLUMNS}x${LINES}"

#trap 'COLUMNS=$(tput cols) LINES=$(tput lines)' WINCH
#
#while sleep 1; do
#    echo "Window: ${COLUMNS}x${LINES}"
#done

winchange() {
    COLUMNS=$(tput cols)
    LINES=$(tput lines)
    echo "Window changed to ${COLUMNS}x${LINES}"
}

trap 'winchange' WINCH
echo "Press any key to exit."
read -e -n 1 -s
