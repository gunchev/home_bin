#!/bin/bash

if [ "$DESKTOP_SESSION" == "lxqt" ]; then
    /usr/bin/ssh-add &
fi
