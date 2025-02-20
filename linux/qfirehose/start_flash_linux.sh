#!/bin/bash


######################################################################################
# Place this script in the directory of your extracted Quectel Firmware
# Ensure qfirehose is installed and part of your system $PATH
# Ensure the serial option driver is installed and the modem is connected by USB
# Ensure the script has executable permisions then run this script to begin the flash
######################################################################################


# Check if the script is run as root. If not, rerun with sudo.
if [ "$(id -u)" -ne 0 ]; then
    echo "Script is not running as root. Re-executing with sudo..."
    exec sudo "$0" "$@"
fi

# Check if qfirehose exists in PATH
if ! command -v qfirehose &> /dev/null; then
    echo "Error: qfirehose command not found in PATH"
    echo "Please install qfirehose or ensure it's in your PATH"
    exit 1
fi

# Create log file name with current date and time
LOG_FILE="./flash_$(date '+%Y%m%d_%H%M%S').log"

# Redirect all output to both console and log file
exec 1> >(tee -a "$LOG_FILE")
exec 2>&1

echo "Starting flashing process..."
echo "Log file: $LOG_FILE"

# Run qfirehose command
qfirehose -f ./

# Add press any key prompt
read -n 1 -s -r -p "Press any key to exit..."
echo # Move to a new line after key press
exit 0
