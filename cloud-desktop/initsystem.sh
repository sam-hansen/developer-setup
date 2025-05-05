#!/bin/bash
# Start a new D-Bus session and export the address
eval "$(dbus-launch --sh-syntax)"
export DBUS_SESSION_BUS_ADDRESS
export DBUS_SESSION_BUS_PID

# Now start your main application (replace with your actual command)
exec sunshine &
