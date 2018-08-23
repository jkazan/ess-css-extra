#!/bin/bash
#

cd ..

find . -type d -name target

read -p "Do you want to remove the found target folders and local Mavem p2 repository [y/n]? " -n 1 -r
echo    # (optional) move to a new line

if [[ $REPLY =~ ^[Yy]$ ]]
then
  echo "Deleting the found target folders and local Mavem p2 repository..."
  find . -depth -type d -name target -exec rm -frv {} \;
  rm -frv ~/.m2/repository/p2
fi
