# Instructions
## Case Scenario
A staff member has requested a list of the names of the services recognized by the current Linux image. A file named /etc/services has been located that contains the pertinent information; however it is not organized to easily determine all of the services.

Using a combination of pipes, redirects and control statements, produce output that contains only the service names. The entire task must be accomplished without using any intermediary files. Each service should only be listed once and captured to a file named uniqueservices.txt, located in the home directory. Remove any blank lines or lines that are deemed to be comments.

There could be more than one possible solution for obtaining the desired results.

## Objectives
- Extract all the service names from the file.
- Sort the names alphabetically removing any duplicates.
- Remove any blank lines or lines that do not begin with a letter of the alphabet.
- Capture the final output to a file named uniqueservices.txt.
- Count the lines in the file using a conditional command that is only executed if the previous combined commands are successful.

## Command result
awk '/^[[:alpha:]]/ { services[$1] } END { PROCINFO["sorted_in"] = "@val_type_asc"; for (s in services) print s }' /etc/services > ~/uniqueservices.txt && wc -l ~/uniqueservices.txt