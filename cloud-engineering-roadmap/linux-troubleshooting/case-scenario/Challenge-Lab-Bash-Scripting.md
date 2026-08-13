# Instructions

## Case Scenario
In the User Management challenge lab, you were tasked with creating users and groups. Using the commands one at a time from the command line can be a tedious process and could lead to potential errors in syntax. It is your duty, as an administrator, to make the process as seamless and efficient as possible.

## Objectives
- Create a bash script to perform user management tasks as outlined below:
- Create a new group. Each group must have a unique name. The script must check to ensure that no duplicate group names exist on the system. If a duplicate is found, an error needs to be reported, and the administrator must try another group name.
- Create a new user. Each user must have a unique name. The script must check to ensure that no duplicate usernames exist on the system. If a duplicate is found, an error needs to be reported and the administrator must try another username. The user will have a Bash login shell and belong to the group that was created in the previous step.
- Create a password for each user that is created.
- Ensure that the new user created is a member of the new group created.
- Create a directory at the root / of the file system with same name as the user created.
- Set the ownership of the directory to the user and group created.
- Set the permissions of the directory to full control for the owner and full control for the group created.
- Set the permissions to ensure that only the owner of a file can delete it from the directory.
- Ensure that the script is executable.
- This script should be designed to accept any username and any group name. DO NOT hardcode commands to create specific usernames and group names.

## Hints
Logical order is important.
There is a special wildcard that can be used to determine if the previous command is successful or not. This will be useful for this script.

## Script
user_mgmt.sh