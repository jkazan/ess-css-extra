#!/bin/sh
#

START=$(date +%s)

cd ..

# To start fresh, clean your local repository
# If you have accidentally invoked
#   mvn install
# or want to assert that you start over fresh,
# delete the Maven repository:
rm -rf $HOME/.m2/repository
rm -f ?_*.log

echo "===="
echo "==== BUILDING maven-osgi-bundles"
echo "===="
(cd maven-osgi-bundles; time mvn clean verify) | tee 0_maven-osgi-bundles.log

echo "===="
echo "==== BUILDING cs-studio-thirdparty"
echo "===="
(cd cs-studio-thirdparty; time mvn clean verify) | tee 1_cs-studio-thirdparty.log

echo "===="
echo "==== BUILDING diirt"
echo "===="
(cd diirt; time mvn clean verify) | tee 2_diirt.log

echo "===="
echo "==== BUILDING cs-studio/core"
echo "===="
(cd cs-studio/core; time mvn clean verify) | tee 3_cs-studio-core.log

echo "===="
echo "==== BUILDING cs-studio/applications"
echo "===="
(cd cs-studio/applications; time mvn clean verify) | tee 4_cs-studio-applications.log

echo "===="
echo "==== BUILDING cs-studio/applications"
echo "===="
(cd org.csstudio.display.builder; time mvn -Dcss-repo=file:/Users/claudiorosati/Projects/GitHub/ess-css-extra/ess_css_comp_repo -Declipse-site=http://download.eclipse.org/releases/neon clean verify) | tee 5_org.csstudio.display.builder.log

echo "===="
echo "==== BUILDING org.csstudio.product"
echo "===="
(cd org.csstudio.product; time mvn clean verify) | tee 6_org.csstudio.product.log

echo "===="
echo "==== BUILDING org.csstudio.ess.product"
echo "===="
(cd org.csstudio.ess.product; time mvn clean verify) | tee 7_org.csstudio.ess.product.log

# Displaying execution time
DUR=$(echo "$(date +%s) - $START" | bc)
MDUR=`expr $DUR / 60`; \
SDUR=`expr $DUR - 60 \* $MDUR`; \
echo "===="
echo "==== Building took $MDUR minutes and $SDUR seconds."
echo "===="
