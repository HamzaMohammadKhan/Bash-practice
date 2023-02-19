#Exercise_6 - write a shell script that prompts the user for a name of a file or directory and reports if it is a regular file, 
#a directory, or another type of file. Also perform an ls command against the file or directory with the long listing option.

#!/bin/bash

read -p "enter file path : " FILE

if  [[ -f $FILE ]]
	then 
	echo "File exists"
elif [[ -d $FILE ]]
	then
	echo "It is a $FILE"
#elif [[ -d $FILE ]] 
#	then
#	echo "It is a $FILE"	
fi
 ls -al $FILE	
