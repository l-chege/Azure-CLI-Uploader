#!/bin/bash

INSTALL_DIR="/usr/local/bin"

#define name of the script
SCRIPT_NAME="cliscript.sh"

#check if main script file already exists
if [ -f "$INSTALL_DIR/$SCRIPT_NAME" ]; then
    echo "Script is already installed."
    exit 1
    fi

#copy main script to install directory
cp "$SCRIPT_NAME"  "$INSTALL_DIR"

#make script executable
chmod +x "$INSTALL_DIR/$SCRIPT_NAME"

#check if directory is in path
if [[ ":$PATH:" == *":$INSTALL_DIR:"* ]]; then
    echo "Successful installation. Directory is in path and can be used."
    else
    echo "Successful installation. Directory is not in path"
    fi