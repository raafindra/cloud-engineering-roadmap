# Instructions
## Case Scenario
There has been suspicious activity on the system. In order to preserve log information, it will be necessary to archive the current files in /var/log ending with the .log extension. The files are to be saved to a file named log.tar, stored in the directory, ~/archive.
It has also been requested that the files that were archived be saved to a directory, ~/backup.

## Objectives
1. Create an archive named log.tar that is stored in the archive directory located in the home directory.
2. Remove path names from the files that are archived.
3. Produce verbose output while archiving.
4. List the contents of the archive without extracting.
5. Extract the files to the directory, ~/backup.

## Script
archive_logs.sh