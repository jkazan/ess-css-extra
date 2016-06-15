#!/bin/sh

cd ..

# To start fresh, clean your local repository
# If you have accidentally invoked
#   mvn install
# or want to assert that you start over fresh,
# delete the Maven repository:
rm -rf $HOME/.m2/repository

# If you want to compile the maven-osgi-bundles
# and listed its local repo in your composite repo,
# do it.
# Otherwise skip this step, and use the only repo
# for this module.
echo "===="
echo "==== BUILDING maven-osgi-bundles"
echo "===="
(cd maven-osgi-bundles; mvn clean verify)

# Similarly, compile cs-studio-thirdparty unless
# you prefer to use its binaries from a remote repo.
echo "===="
echo "==== BUILDING cs-studio-thirdparty"
echo "===="
(cd cs-studio-thirdparty; mvn clean verify)

# Again if you prefer local mud
echo "===="
echo "==== BUILDING diirt"
echo "===="
(cd diirt; mvn clean verify)

# If you want to compile core, ..
echo "===="
echo "==== BUILDING cs-studio/core"
echo "===="
(cd cs-studio/core; mvn clean verify)

# If you want to compile applications, ..
echo "===="
echo "==== BUILDING cs-studio/applications"
echo "===="
(cd cs-studio/applications; mvn clean verify)

# Compile desired products
echo "===="
echo "==== BUILDING org.csstudio.ess.product"
echo "===="
(cd org.csstudio.ess.product; mvn clean verify)
