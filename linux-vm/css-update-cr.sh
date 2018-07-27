#!/bin/bash
# DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS HEADER.
# Copyright (C) 2016 European Spallation Source ERIC.


# Print usage function.
print_usage()
{
  echo "Usage: css-update [-d] <version>"
  echo "  -d        Updates from the 'development' repository."
  echo "  <version> The required version number in <major>.<minor>.<release>.<build> format."
}


# Getting old cs-studio version.
OLD_VERSION=$(cat /opt/cs-studio/ess-version.txt)


# Download required version into a temporary folder.
TMP_FOLDER=`mktemp -d 2>/dev/null || mktemp -d -t 'cs-studio'`
TARGET_NAME="cs-studio-"

cd $TMP_FOLDER

if [ $# -lt 1 ]; then
  print_usage
elif [ $# -lt 2 ]; then
  if [ "$1" == '-d' ]; then
    print_usage
  else
    NEW_VERSION=$1
    TARGET_NAME=$TARGET_NAME"production-"$NEW_VERSION
    wget "https://artifactory.esss.lu.se/artifactory/CS-Studio/production/$NEW_VERSION/cs-studio-ess-$NEW_VERSION-linux.gtk.x86_64.tar.gz"
  fi
else
  if [ "$1" == '-d' ]; then
    NEW_VERSION=$2
    TARGET_NAME=$TARGET_NAME"development-"$NEW_VERSION
    wget "https://artifactory.esss.lu.se/artifactory/CS-Studio/development/$NEW_VERSION/cs-studio-ess-$NEW_VERSION-linux.gtk.x86_64.tar.gz"
  else
    print_usage
  fi
fi

if [ -f cs-studio-ess-$NEW_VERSION-linux.gtk.x86_64.tar.gz ]; then
  tar -zxvf cs-studio-ess-$NEW_VERSION-linux.gtk.x86_64.tar.gz
  if [ -d cs-studio ]; then
    echo "Updating CS-Studio from version $OLD_VERSION to version $NEW_VERSION"
    sudo rm -fr /opt/cs-studio-$OLD_VERSION 2>/dev/null
    sudo mv /opt/cs-studio /opt/cs-studio-$OLD_VERSION
    sudo mv cs-studio /opt/$TARGET_NAME
    ln -Ffs /opt/$TARGET_NAME /opt/cs-studio
  fi
fi

cd ~
sudo rm -fr $TMP_FOLDER
