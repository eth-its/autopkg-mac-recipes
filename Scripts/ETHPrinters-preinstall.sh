#!/bin/bash

# install a fresh copy of each of the printer drivers
jamf policy -event "ETH Printer Drivers HP S-install" -forceNoRecon
jamf policy -event "ETH Printer Drivers HP SE-install" -forceNoRecon
jamf policy -event "ETH Printer Drivers Ricoh Vol3-install" -forceNoRecon
jamf policy -event "ETH Printer Drivers Ricoh Vol4-install" -forceNoRecon

# delete the old version of the app if it is installed
if [[ -d "/Applications/Utilities/ETH Printers.app" ]]; then
    rm -Rf "/Applications/Utilities/ETH Printers.app"
    # forget package
    pkgutil --pkgs=ch.ethz.ethprinters.pkg && pkgutil --forget ch.ethz.ethprinters.pkg ||:
fi

