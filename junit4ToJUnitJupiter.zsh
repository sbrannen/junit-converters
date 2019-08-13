#!/bin/zsh

########################################################################
#
# Script for converting JUnit 4 code to JUnit Jupiter code on Mac OS X.
#
# This script does not migrate use of the `exception` and `timeout`
# attributes or `@Test`.
#
# This script does not migrate JUnit 4 assertions.
#
########################################################################

for file in src/test/java/**/*.java; do

    # If the test class directly extends TestCase...
    if [[ `grep -m 1 -c -e '.*class .*Tests.*' ${file}` -ge 1 ]]; then

        echo "Processing: ${file}\n"

        # Replace JUnit 4's @Test, @BeforeClass, @AfterClass, @Before, 
		# @After, and @Ignore annotations with their JUnit Jupiter
		# counterparts.
        if [[ `grep -m 1 -c 'org.junit.Test' ${file}` -gt 0 ]]; then
            perl -0777 -pi -e 's/org\.junit\.Test/org.junit.jupiter.api.Test/g' $file
        fi
        if [[ `grep -m 1 -c 'org.junit.BeforeClass' ${file}` -gt 0 ]]; then
            perl -0777 -pi -e 's/org\.junit\.BeforeClass/org.junit.jupiter.api.BeforeAll/g' $file
        fi
        if [[ `grep -m 1 -c 'org.junit.AfterClass' ${file}` -gt 0 ]]; then
            perl -0777 -pi -e 's/org\.junit\.AfterAll/org.junit.jupiter.api.AfterAll/g' $file
        fi
        if [[ `grep -m 1 -c 'org.junit.Before' ${file}` -gt 0 ]]; then
            perl -0777 -pi -e 's/org\.junit\.Before/org.junit.jupiter.api.BeforeEach/g' $file
        fi
        if [[ `grep -m 1 -c 'org.junit.After' ${file}` -gt 0 ]]; then
            perl -0777 -pi -e 's/org\.junit\.After/org.junit.jupiter.api.AfterEach/g' $file
        fi
        if [[ `grep -m 1 -c 'org.junit.Ignore' ${file}` -gt 0 ]]; then
            perl -0777 -pi -e 's/org\.junit\.Ignore/org.junit.jupiter.api.Disabled/g' $file
        fi

        if [[ `grep -m 1 -c '@BeforeClass' $file` -gt 0 ]]; then
            perl -0777 -pi -e 's/\@BeforeClass/\@BeforeAll/g' $file
        fi
        if [[ `grep -m 1 -c '@AfterClass' $file` -gt 0 ]]; then
            perl -0777 -pi -e 's/\@AfterClass/\@AfterAll/g' $file
        fi
        if [[ `grep -m 1 -c '@Before' $file` -gt 0 ]]; then
            perl -0777 -pi -e 's/\@Before/\@BeforeEach/g' $file
        fi
        if [[ `grep -m 1 -c '@After' $file` -gt 0 ]]; then
            perl -0777 -pi -e 's/\@After/\@AfterEach/g' $file
        fi
        if [[ `grep -m 1 -c '@Ignore' $file` -gt 0 ]]; then
            perl -0777 -pi -e 's/\@Ignore/\@Disabled/g' $file
        fi

        # Replace @RunWith(MockitoJUnitRunner.class) with 
		# @ExtendWith(MockitoExtension.class).
        if [[ `grep -m 1 -c 'org.junit.runner.RunWith' ${file}` -gt 0 ]]; then
            perl -0777 -pi -e 's/org\.junit\.runner\.RunWith/org.junit.jupiter.api.extension.ExtendWith/g' $file
        fi
        if [[ `grep -m 1 -c 'org.mockito.junit.MockitoJUnitRunner' ${file}` -gt 0 ]]; then
            perl -0777 -pi -e 's/org\.mockito\.junit\.MockitoJUnitRunner/org.mockito.junit.jupiter.MockitoExtension/g' $file
        fi
        if [[ `grep -m 1 -c '@RunWith' ${file}` -gt 0 ]]; then
            perl -0777 -pi -e 's/\@RunWith/\@ExtendWith/g' $file
        fi
        if [[ `grep -m 1 -c 'MockitoJUnitRunner' ${file}` -gt 0 ]]; then
            perl -0777 -pi -e 's/MockitoJUnitRunner/MockitoExtension/g' $file
        fi

    fi

done
