#!/bin/bash
#

export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_172.jdk/Contents/Home

echo ""
echo "===="
echo "==== JDK used: " $JAVA_HOME
echo "===="

START=$(date +%s)

cd ..

# To start fresh, clean your local repository
# If you have accidentally invoked
#   mvn install
# or want to assert that you start over fresh,
# delete the Maven repository:
# rm -rf $HOME/.m2/repository
# rm -rf $HOME/.m2/repository/p2/bundle/osgi/org.csstudio.*
# rm -rf $HOME/.m2/repository/p2/bundle/osgi/org.diirt.*
rm -f ?_*.log

# To reduce maven verbosity
# MAVEN_OPTS = $MAVEN_OPTS -Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=warn
# MVNOPT="-P !cs-studio-sites,!eclipse-sites -B -DlocalArtifacts=ignore"
MVNOPT="-B -P ess-css-settings,platform-default,csstudio-composite-repo-enable,eclipse-sites -Dmaven.test.skip=true -DskipTests=true"

echo ""
echo "===="
echo "==== BUILDING maven-osgi-bundles"
echo "===="
# (cd maven-osgi-bundles; time mvn $MVNOPT --settings ../ess-css-extra/maven/settings.xml clean verify) | tee 0_maven-osgi-bundles.log

echo ""
echo "===="
echo "==== BUILDING cs-studio-thirdparty"
echo "===="
# (cd cs-studio-thirdparty; time mvn $MVNOPT --settings ../ess-css-extra/maven/settings.xml clean verify) | tee 1_cs-studio-thirdparty.log

echo ""
echo "===="
echo "==== BUILDING diirt"
echo "===="
# (cd diirt; time mvn $MVNOPT --settings ../ess-css-extra/maven/settings.xml clean verify) | tee 2_diirt.log

echo ""
echo "===="
echo "==== BUILDING cs-studio/core"
echo "===="
# (cd cs-studio/core; time mvn $MVNOPT --settings ../../ess-css-extra/maven/settings.xml clean verify) | tee 3_cs-studio-core.log

echo ""
echo "===="
echo "==== BUILDING cs-studio/applications"
echo "===="
# (cd cs-studio/applications; time mvn $MVNOPT --settings ../../ess-css-extra/maven/settings.xml clean verify) | tee 4_cs-studio-applications.log

echo ""
echo "===="
echo "==== BUILDING org.csstudio.display.builder"
echo "===="
(cd org.csstudio.display.builder; time mvn $MVNOPT --settings ../ess-css-extra/maven/settings.xml -Dcss_repo=file:/Users/claudiorosati/Projects/GitHub/ess-css-extra/ess_css_comp_repo clean verify) | tee 5_org.csstudio.display.builder.log

echo ""
echo "===="
echo "==== BUILDING org.csstudio.ess.product"
echo "===="
(cd org.csstudio.ess.product; time mvn $MVNOPT --settings ../ess-css-extra/maven/settings.xml clean verify) | tee 7_org.csstudio.ess.product.log

echo ""
tail ?_*.log
echo ""

# Displaying execution time
DUR=$(echo "$(date +%s) - $START" | bc)
MDUR=`expr $DUR / 60`; \
SDUR=`expr $DUR - 60 \* $MDUR`; \
echo "===="
echo "==== Building took $MDUR minutes and $SDUR seconds."
echo "===="
