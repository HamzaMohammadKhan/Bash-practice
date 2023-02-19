#!/bin/bash

#Exercise_4 - Write a shell script to check to see if the file “file_path” exists.
#If it does exist, display “file_path passwords are enabled.” Next,
#check to see if you can write to the file. If you can, display 
#“You have permissions to edit “file_path.””If you cannot, display “You do NOT have permissions to edit “file_path””

read -p " enter file path : " FILE
echo $FILE


if [[ -e $FILE ]]

then
echo " file exist " 

else
echo "file does not exist"

fi
#if [ $FILE == false
