#!/bin/bash

filter=%EXTENSION_ATTRIBUTE_VALUE%
# filter=$1  # TEMP

if [[ $filter == "8" ]]; then 
    filter_name="1.8"
elif [[ $filter == "11" ]]; then
    filter_name="11"
else
    latest_jvm="None"
fi

if [[ $filter_name ]]; then
    temp_file="/tmp/jamf_java_versions_extension_attribute_check.plist"
    /usr/libexec/java_home -X -v $filter_name > "$temp_file"
    latest_jvm=$(/usr/libexec/PlistBuddy -c "Print :0:JVMVersion" "$temp_file" 2>/dev/null)
    rm -f "$temp_file"
fi

[[ $latest_jvm == "" ]] && latest_jvm="None"

echo "<result>$latest_jvm</result>"

exit 0