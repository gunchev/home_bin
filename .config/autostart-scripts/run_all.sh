#!/bin/bash

for i in ~/.config/autostart-scripts/*.sh; do
    if [ "${0/*\//}" == "${i/*\//}" ]; then continue; fi
    "$i"
done
