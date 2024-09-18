#!/bin/sh

# Move focus to the next pane
zellij action focus-next-pane

# Get the running command in the current pane
RUNNING_COMMAND=$(zellij action list-clients | awk 'NR==2 {print $3}')


SESSION_NAME=$(zellij list-sessions | tail -n 1 | awk '{print $1}')

if [ ! -d /tmp/${SESSION_NAME} ]; then
    zellij action new-pane
    sleep 0.4
    # Get the working directory
    if [ -d "$1" ]; then
        WORKING_DIR="$1"
    else
        WORKING_DIR=$(dirname "$1")
    fi
    zellij action write-chars "hx $1 -w $WORKING_DIR"
    zellij action write 13
    mkdir -p /tmp/${SESSION_NAME}
elif [ ! -e /tmp/${SESSION_NAME}/.open ];  then
    # The current pane is not running helix, so open helix in a new pane
    zellij action new-pane
    sleep 0.4
    # Get the working directory
    if [ -d "$1" ]; then
        WORKING_DIR="$1"
    else
        WORKING_DIR=$(dirname "$1")
    fi
    zellij action write-chars "hx $1 -w $WORKING_DIR"
    zellij action write 13
    touch /tmp/${SESSION_NAME}/.open
    exit 0
else
    # The current pane is running helix, use zellij actions to open the file
    zellij action write 27
    zellij action write-chars ":open $1"
    zellij action write 13
fi
