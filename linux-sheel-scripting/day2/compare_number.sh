#!/bin/bash

read -p "Enter first number : " Fnumber
read -p "Enter second number : " Snumber

if [ $Fnumber -eq $Snumber ]; then
    echo "first number "$Fnumber" equal with second number "$Snumber
else
     echo "first number "$Fnumber" not equal with second number "$Snumber
fi