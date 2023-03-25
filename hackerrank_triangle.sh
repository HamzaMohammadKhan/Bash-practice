read -p "Enter 1st number : " a
read -p "Enter 2nd number : " b
read -p "Enter 3nd number : " c

if [[ $a -eq $b ]] && [[ $b -eq $c ]]
then
echo "EQUILATERAL"
elif [[ $a -eq $b ]] || [[ $b -eq $c ]] || [[ $a -eq $c ]]
then
echo "ISOSCELES"
else
echo "SCALENE"
fi
