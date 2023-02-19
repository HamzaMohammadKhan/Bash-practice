#!/bin/bash

#Exercise_5 - Write a shell script that displays “man”,”bear”,”pig”,”dog”,”cat”,and “sheep” 
#on the screen with each appearing on a separate line. Try to do this in as few lines as possible.

animals="man pig dog bear cat sheep"

arr=(${animals})

echo ${arr[@]}

#printf "'%s'\n" "${arr[@]}" 
