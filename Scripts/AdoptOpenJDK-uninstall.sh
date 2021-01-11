#!/bin/bash

filter="$4"
has_jvm=1

if [[ $filter == "8" ]]; then 
    filter_name="jdk8"
elif [[ $filter == "11" ]]; then
    filter_name="jdk-11"
else
    echo "No JVM version chosen"
    exit 1
fi

while [[ $has_jvm == 1 ]]; do
    jvm_path=$(find /Library/Java/JavaVirtualMachines -name "$filter_name*" -maxdepth 1 | head -n 1)
    if [[ -d "$jvm_path" ]]; then
        echo "Deleting '$jvm_path'"
        rm -Rf "$jvm_path"
    else
        echo "No JVM with version $filter is installed"
        has_jvm=0
    fi
done
