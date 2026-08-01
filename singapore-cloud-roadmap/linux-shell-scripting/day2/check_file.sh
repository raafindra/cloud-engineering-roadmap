#!/bin/bash

# Check whether file exists

if [ -f checkfile.txt ]; then
    echo "file exist"
else
    echo "file not exist"
    exit 1
fi