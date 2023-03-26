read -p "enter first number : " x
read -p "enter second number : " y

#if [[ $x -gt $y ]]
#then
#echo "X is greater than Y"
#elif [[ $x -lt $y ]]
#then
#echo "X is less than Y"
#elif [[ $x -eq $y ]]
#then
#echo "X is equal to Y"
#fi 

if (( $x > $y ))
then
echo "X is greater than Y"
elif (( $x < $y ))
then
echo "X is less than Y"
elif (( $x == $y ))
then
echo "X is equal to Y"
fi
