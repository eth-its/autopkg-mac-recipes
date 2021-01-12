#!/bin/bash

#######################################################################
#
# %NAME% Uninstaller Script for Jamf Pro
#
# This script can delete apps that are sandboxed and live in /Applications
#
#######################################################################

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
            if pgrep -f "/$check_app_name" ; then
                (( n=n+1 ))
                sleep 1
				echo "Graceful close attempt # $n"
            else
                echo "$app_name closed."
                break
            fi
        done
        if pgrep -f "/$check_app_name" ; then
            echo "$app_name failed to quit - killing."
            /usr/bin/pkill -f "/$check_app_name"
        fi
    fi
}

# Inputted variables
app_name="%JSS_INVENTORY_NAME%"

if [[ -z "${app_name}" ]]; then
    echo "No application specified!"
    exit 1
fi

# quit the app if running
silent_app_quit "$app_name"


# Now remove the app
echo "Removing application: ${app_name}"

# Add .app to end when providing just a name e.g. "TeamViewer"
if [[ ! $app_name == *".app"* ]]; then
	app_name=$app_name".app"
fi

# Add standard path if none provided
if [[ ! $app_name == *"/"* ]]; then
	app_to_trash="/Applications/$app_name"
else
	app_to_trash="$app_name"
fi

echo "Application will be deleted: $app_to_trash"
# Remove the application
/bin/rm -rf "${app_to_trash}"

echo "Checking if $app_name is actually deleted..."
if [[ -d "${app_to_trash}" ]]; then
    echo "$app_name failed to delete"
else
    echo "$app_name deleted successfully"
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

echo "$app_name deletion complete"