#!/bin/sh

# install a fresh copy of each of the printer drivers
jamf policy -event "ETH Printer Drivers HP S-install" -forceNoRecon
jamf policy -event "ETH Printer Drivers HP SE-install" -forceNoRecon
jamf policy -event "ETH Printer Drivers Ricoh Vol3-install" -forceNoRecon
jamf policy -event "ETH Printer Drivers Ricoh Vol4-install" -forceNoRecon

# delete the old version of the app if it is installed
