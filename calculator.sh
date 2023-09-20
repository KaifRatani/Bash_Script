#! /usr/bin/bash -u
#Kaif Ratani - 041076291

# Store the operation (+, -, *, /) in the variable 'w'
w=$1 

# Store the string "enter + - '*' '/' " in the variable 'sum'
sum="enter + - '*' '/' "

# Store the first number in the variable 'num1'
num1=$2 

# Store the second number in the variable 'num2'
num2=$3 

# Check the value of 'w' to determine the operation
if [[ $w == + ]]
then
    # Perform addition and store the result in 'sum'
    sum=$(( $num1 + $num2 ))   
elif [[ $w == - ]]
then
    # Perform subtraction and store the result in 'sum'
    sum=$(( $num1 - $num2 ))
elif [[ $w == '*' ]]
then
    # Perform multiplication and store the result in 'sum'
    sum=$((num1 * num2))
elif [[ $w == '/' ]]
then
    # Perform division and store the result in 'sum'
    sum=$((num1 / num2))
else 
    # If 'w' does not match any of the valid operations, print an error message
    echo "invalid input"
fi

# Print the final result stored in 'sum'
echo $sum
echo "$num1 $w $num2 = $sum" >> cal.log

