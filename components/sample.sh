#!bin/bash

read -p "enter quantity :" qt

if [ $qt -lt 1000 ]
then
  echo "No discount"
elif [ $qt -lt 2000 ]
then
  echo "15% discount"
elif [ $qt -gt 5000 ]
then
  echo "25% discount"
fi
