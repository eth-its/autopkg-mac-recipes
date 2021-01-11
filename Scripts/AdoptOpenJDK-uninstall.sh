#!/bin/bash

filter=%SCRIPT_PARAMETER4%
active_jvm=1

while [[ $active_jvm == 1 ]]; do
    active_jvm_path=$(/usr/libexec/java_home -V 2>/dev/null | tail -n 1 | grep $filter | sed 's|/Contents/Home||')
    if [[ -d "$active_jvm_path" ]]; then
        echo "Deleting '$active_jvm_path'"
        rm -rf "$active_jvm_path"
    else
        echo "No active JVM"
        active_jvm=0
    fi
done


