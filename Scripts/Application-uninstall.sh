#!/bin/bash

#######################################################################
#
# %NAME% Uninstaller Script for Jamf Pro
#
# This script can delete apps that are sandboxed and live in /Applications
#
#######################################################################

# Inputted variables
appName="%JSS_INVENTORY_NAME%"

function silent_app_quit() {
    # silently kill the application.
    # add .app to end of string if not supplied
    appName="${appName/\.app/}"            # remove any .app
    appNameCheck="${appName/\(/\\(}"       # escape any brackets for the pgrep
    appNameCheck="${appNameCheck/\)/\\)}"  # escape any brackets for the pgrep
    appNameCheck="${appNameCheck}.app"     # add the .app back
    if [[ $(ps aux | grep "/${appNameCheck}" | grep -v grep) ]]; then
        echo "Closing $appName"
        /usr/bin/osascript -e "quit app \"$appName\""
        sleep 1

        # double-check
        countUp=0
        while [[ $countUp -le 10 ]]; do
            if [[ -z $(pgrep -ix "$appNameCheck") ]]; then
                echo "$appName closed."
                break
            else
                (( countUp=countUp+1 ))
                sleep 1
            fi
        done
        if [[ $(pgrep -x "$appNameCheck") ]]; then
            echo "$appName failed to quit - killing."
            /usr/bin/pkill "$appNameCheck"
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

# Add .app to end when providing just a name e.g. "TeamViewer"
if [[ ! $appName == *".app"* ]]; then
	appName=$appName".app"
fi

# Add standard path if none provided
if [[ ! $appName == *"/"* ]]; then
	appToDelete="/Applications/$appName"
else
	appToDelete="$appName"
fi

echo "Application will be deleted: $appToDelete"
# Remove the application
/bin/rm -rf "${appToDelete}"

echo "Checking if $appName is actually deleted..."
if [[ -d "${appToDelete}" ]]; then
    echo "$appName failed to delete"
else
    echo "$appName deleted successfully"
fi

# Try to Forget the packages if we can find a match
# Loop through the remaining parameters
pkg_1="%PKG_ID%"
pkg_2="%PKG_ID_2%"
pkg_3="%PKG_ID_3%"
pkg_4="%PKG_ID_4%"
pkg_5="%PKG_ID_5%"
for (( i = 1; i < 5; i++ )); do
    pkg_id=pkg_$i
    if [[ ${!pkg_id} != "None" ]]; then
        echo "Forgetting package ${!pkg_id}..."
        /usr/sbin/pkgutil --pkgs | /usr/bin/grep -i "${!pkg_id}" | /usr/bin/xargs /usr/bin/sudo /usr/sbin/pkgutil --forget
    fi
done

echo "$appName deletion complete"