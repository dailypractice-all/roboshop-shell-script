#!bin/bash

n%2 = $1
if [ $1 -eq 0 ]; then
  echo -e "\e[31mFAILED\e[0m"
  exit 2
else
  echo -e "\e[32mSUCESS\e[0m"
fi
}