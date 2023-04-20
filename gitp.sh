#!/bin/sh

#1
git add .
read -p "commit message: " message


git commit -m "$message"

#2 push
git push
