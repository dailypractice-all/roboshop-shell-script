#!bin/bash

read -p "Enter Number: " num
if [ $num % 2 -eq 0 ]
then
  echo "Even number"

elif [ $num % 2 -ne 0 ]
then
  echo "Odd number"

else
  echo "nither even nor odd"
fi