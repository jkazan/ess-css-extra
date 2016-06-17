# ess-css-extra
Folder containing all accessory files and folders necessary to compile and deploy ESS version of CS-Studio.
## ess_css_comp_repo
This repository contains the _Composite P2 Repository_ as described in [Control System Studio Guide](http://cs-studio.sourceforge.net/docbook/ch04.html#idp157632), needed to manually build the product using Maven.
## home/dot-profile
This file contains the environment variables to be set and included into the ~/.profile file.
## maven/settings.xml
This is the Maven settings file that should be copied into ~/.m2 to configure Maven to use the composite P2 repository.
## clean-and-build.sh
This shell-script file will allow cleaning and rebuilding all the artifacts.
