#!/bin/bash

filter=%EXTENSION_ATTRIBUTE_VALUE%
# filter=$1  # TEMP

temp_file="/tmp/jamf_java_versions_extension_attribute_check.plist"
/usr/libexec/java_home -X -v $filter > "$temp_file"
latest_jvm=$(/usr/libexec/PlistBuddy -c "Print :0:JVMVersion" "$temp_file" 2>/dev/null)
rm -f "$temp_file"
echo "<result>$latest_jvm</result>"

exit 0