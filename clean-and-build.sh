#!/bin/sh

START=$(date +%s)

cd ..

# To start fresh, clean your local repository
# If you have accidentally invoked
#   mvn install
# or want to assert that you start over fresh,
# delete the Maven repository:
rm -rf $HOME/.m2/repository

echo "===="
echo "==== BUILDING maven-osgi-bundles"
echo "===="
(cd maven-osgi-bundles; mvn clean verify)

echo "===="
echo "==== BUILDING cs-studio-thirdparty"
echo "===="
(cd cs-studio-thirdparty; mvn clean verify)

echo "===="
echo "==== BUILDING diirt"
echo "===="
(cd diirt; mvn clean verify)

echo "===="
echo "==== BUILDING cs-studio/core"
echo "===="
(cd cs-studio/core; mvn clean verify)

echo "===="
echo "==== BUILDING cs-studio/applications"
echo "===="
(cd cs-studio/applications; mvn clean verify)

echo "===="
echo "==== BUILDING org.csstudio.product"
echo "===="
(cd org.csstudio.product; mvn clean verify)

echo "===="
echo "==== BUILDING org.csstudio.ess.product"
echo "===="
(cd org.csstudio.ess.product; mvn clean verify)

# Displaying execution time
DUR=$(echo "$(date +%s) - $START" | bc)
MDUR=`expr $DUR / 60`; \
SDUR=`expr $DUR - 60 \* $MDUR`; \
echo "===="
echo "==== Building took $MDUR minutes and $SDUR seconds."
echo "===="

