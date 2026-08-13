#!/bin/bash

# Ensure script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Error: This script must be run as root (or via sudo)." >&2
    exit 1
fi

echo "=========================================="
echo "    Automated User Management Script      "
echo "=========================================="

# ------------------------------------------------------------------
# Step 1: Prompt for and validate Group Name
# ------------------------------------------------------------------
while true; do
    read -p "Enter new group name: " GROUP_NAME

    # Check if group name input is empty
    if [ -z "$GROUP_NAME" ]; then
        echo "Error: Group name cannot be empty. Please try again."
        continue
    fi

    # Check if group already exists
    getent group "$GROUP_NAME" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "Error: Group '$GROUP_NAME' already exists! Please enter a different group name."
    else
        break
    fi
done

# Create the group
groupadd "$GROUP_NAME"
if [ $? -eq 0 ]; then
    echo "SUCCESS: Group '$GROUP_NAME' created successfully."
else
    echo "Error: Failed to create group '$GROUP_NAME'." >&2
    exit 1
fi

# ------------------------------------------------------------------
# Step 2: Prompt for and validate Username
# ------------------------------------------------------------------
while true; do
    read -p "Enter new username: " USER_NAME

    # Check if username input is empty
    if [ -z "$USER_NAME" ]; then
        echo "Error: Username cannot be empty. Please try again."
        continue
    fi

    # Check if user already exists
    getent passwd "$USER_NAME" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "Error: User '$USER_NAME' already exists! Please enter a different username."
    else
        break
    fi
done

# Create the user with Bash shell and primary group set to $GROUP_NAME
useradd -m -g "$GROUP_NAME" -s /bin/bash "$USER_NAME"
if [ $? -eq 0 ]; then
    echo "SUCCESS: User '$USER_NAME' created successfully with shell /bin/bash."
else
    echo "Error: Failed to create user '$USER_NAME'." >&2
    exit 1
fi

# ------------------------------------------------------------------
# Step 3: Set Password for the New User
# ------------------------------------------------------------------
echo "Setting password for $USER_NAME..."
passwd "$USER_NAME"
while [ $? -ne 0 ]; do
    echo "Error: Password setup failed or did not match. Please try again."
    passwd "$USER_NAME"
done

# ------------------------------------------------------------------
# Step 4: Create Directory at Root (/) and Set Ownership & Permissions
# ------------------------------------------------------------------
DIR_PATH="/$USER_NAME"

# Create directory
mkdir -p "$DIR_PATH"

# Set ownership to target user and target group
chown "$USER_NAME:$GROUP_NAME" "$DIR_PATH"

# Set permissions:
# 1 = Sticky Bit (Only file owner can delete files inside)
# 7 = Owner (Full Control - rwx)
# 7 = Group (Full Control - rwx)
# 0 = Others (No access - ---)
chmod 1770 "$DIR_PATH"

echo "SUCCESS: Directory '$DIR_PATH' created."
echo "Permissions set to 1770 (Owner: $USER_NAME, Group: $GROUP_NAME, Sticky Bit active)."

echo "=========================================="
echo "    User Management Task Completed!      "
echo "=========================================="