#!/bin/bash

#######################################################################
#
# Remove Application Script for Jamf Pro - adapted for Fiji
#
# This script can delete apps that are sandboxed and live in /Applications

# The first parameter is used to kill the app. It should be the app name or path
# as required by the pkill command.
#
# Date: @@DATE
# Version: @@VERSION
# Origin: @@ORIGIN
# Source name: @@PATH
# Released by JSS User: @@USER
#
#######################################################################

# Inputted variables
appName="Fiji"

function silent_app_quit() {
    # silently kill the application.
    # add .app to end of string if not supplied
    app_name="${app_name/\.app/}"            # remove any .app
    check_app_name="${app_name/\(/\\(}"       # escape any brackets for the pgrep
    check_app_name="${check_app_name/\)/\\)}"  # escape any brackets for the pgrep
    check_app_name="${check_app_name}.app"     # add the .app back
    if pgrep -f "/${check_app_name}" ; then
        echo "Closing $app_name"
        /usr/bin/osascript -e "quit app \"$app_name\"" &
        sleep 1

        # double-check
        n=0
        while [[ $n -lt 10 ]]; do
            if pgrep -f "$check_app_name" ; then
                (( n=n+1 ))
                sleep 1
				echo "Graceful close attempt # $n"
            else
                echo "$app_name closed."
                break
            fi
        done
        if pgrep -f "$check_app_name" ; then
            echo "$app_name failed to quit - killing."
            /usr/bin/pkill -f "$check_app_name"
        fi
    fi
}

if [[ -z "${appName}" ]]; then
    echo "No application specified!"
    exit 1
fi

# quit the app if running
silent_app_quit "$appName"

# Now remove the app
echo "Removing application: ${appName}"

find /Applications -type d -name Fiji* -maxdepth 1 -exec rm -rf {} +

echo "Checking if $appName is actually deleted..."
[[ $(find /Applications -type d -name Fiji* -maxdepth 1) ]] && echo "$appName failed to delete" || echo "$appName deleted successfully"

# Delete the versioning file
echo "Removing /Library/Application Support/Fiji/AdaptedInfo.plist"
rm -f "/Library/Application Support/Fiji/AdaptedInfo.plist" && echo "AdaptedInfo.plist removed" || echo "AdaptedInfo.plist was not removed"

# Try to Forget the package
echo "Forgetting package org.fiji..."
/usr/sbin/pkgutil --forget "org.fiji"

echo "$appName deletion complete"
