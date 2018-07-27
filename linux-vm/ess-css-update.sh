#!/bin/bash
# DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS HEADER.
# Copyright (C) 2016 European Spallation Source ERIC.
#
# This is to be used in the CS-Studio training VM.


# Print usage function.
print_usage()
{
  echo "Usage: ess-css-update [-d] <version>"
  echo "  -d        Updates from the 'development' repository."
  echo "  <version> The required version number in <major>.<minor>.<release>.<build> format."
}


# Download required version into a temporary folder.
TMP_FOLDER=`mktemp -d 2>/dev/null || mktemp -d -t 'cs-studio'`

cd $TMP_FOLDER

if [ $# -lt 1 ]; then
  print_usage
elif [ $# -lt 2 ]; then
  if [ "$1" == '-d' ]; then
    print_usage
  else
    VERSION=$1
    wget "https://artifactory01.esss.lu.se:443/artifactory/CS-Studio/production/$VERSION/cs-studio-ess-$VERSION-linux.gtk.x86_64.tar.gz"
  fi
else
  if [ "$1" == '-d' ]; then
    VERSION=$2
    wget "https://artifactory01.esss.lu.se:443/artifactory/CS-Studio/development/$VERSION/cs-studio-ess-$VERSION-linux.gtk.x86_64.tar.gz"
  else
    print_usage
  fi
fi

if [ -f cs-studio-ess-$VERSION-linux.gtk.x86_64.tar.gz ]; then
  tar -zxvf cs-studio-ess-$VERSION-linux.gtk.x86_64.tar.gz
  if [ -d cs-studio ]; then
    echo "Updating CS-Studio to version $VERSION"
    mv -v cs-studio/ESS\ CS-Studio cs-studio/cs-studio
    mv -v cs-studio/ESS\ CS-Studio.desktop cs-studio/cs-studio.desktop
    mv -v cs-studio/ESS\ CS-Studio.ini cs-studio/cs-studio.ini.original
    mv -v cs-studio/configuration/plugin_customization.ini cs-studio/configuration/plugin_customization.ini.original
    cp -fv ~/configuration/cs-studio.ini cs-studio/
    cp -fv ~/configuration/plugin_customization.ini cs-studio/configuration/
    rm -fr ~/cs-studio
    mv cs-studio ~/
  fi
fi

cd ~
sudo rm -fr $TMP_FOLDER
