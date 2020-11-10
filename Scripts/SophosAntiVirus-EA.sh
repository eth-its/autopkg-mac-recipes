#!/bin/bash

# Get SophosEC PrimaryServerURL

SophosURL=$(/usr/bin/defaults read /Library/Preferences/com.sophos.sau.plist PrimaryServerURL)

echo "<result>$SophosURL</result>"

exit 0
