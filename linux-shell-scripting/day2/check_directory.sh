#!/bin/bash

if [ -d checkfolder ]; then
    echo"folder exist"
else
    echo"folder not exist"
    exit 1
fi
