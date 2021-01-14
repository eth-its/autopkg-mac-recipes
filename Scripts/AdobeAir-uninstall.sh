#!/bin/bash

# Adobe AIR uninstaller

installer="/Applications/Utilities/Adobe AIR Uninstaller.app"

if [[ -d "$installer" ]]; then
    echo "Uninstalling Adobe AIR"
    "$installer/Contents/MacOS/Adobe AIR Installer" -uninstall ||:
fi

if [[ -d "$installer" ]]; then
    echo "Adobe AIR failed to uninstall"
    exit 1
fi

# Forget packages
echo "Forgetting package"
pkgutilcmd="/usr/sbin/pkgutil"
$pkgutilcmd --pkgs=com.adobe.pkg.AIR && $pkgutilcmd --forget com.adobe.pkg.AIR
