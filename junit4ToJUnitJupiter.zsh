#!/bin/zsh

########################################################################
#
# Script for converting JUnit 4 tests to JUnit Jupiter tests in Java,
# Groovy, and Kotlin source code under `src/test/**`.
#
# Tested on Mac OS X.
#
# This script does not migrate the following.
#  - the `exception` and `timeout` attributes of `@Test`
#  - JUnit 4 assertions
#  - JUnit 4 rules
#
########################################################################

setopt null_glob

for file in src/test/**/*.(java|groovy|kt); do

    # If the current file contains a class whose name contains Test,
	# Tests, or TestCase...
    if [[ `grep -m 1 -c -E '.*class .*(Test|Tests|TestCase)+.*' ${file}` -ge 1 ]]; then

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
            perl -0777 -pi -e 's/org\.junit\.AfterClass/org.junit.jupiter.api.AfterAll/g' $file
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

        if [[ `grep -m 1 -c '@BeforeClass' ${file}` -gt 0 ]]; then
            perl -0777 -pi -e 's/\@BeforeClass\n/\@BeforeAll\n/g' $file
        fi
        if [[ `grep -m 1 -c '@AfterClass' ${file}` -gt 0 ]]; then
            perl -0777 -pi -e 's/\@AfterClass\n/\@AfterAll\n/g' $file
        fi
        if [[ `grep -m 1 -c '@Before' ${file}` -gt 0 ]]; then
            perl -0777 -pi -e 's/\@Before\n/\@BeforeEach\n/g' $file
        fi
        if [[ `grep -m 1 -c '@After' ${file}` -gt 0 ]]; then
            perl -0777 -pi -e 's/\@After\n/\@AfterEach\n/g' $file
        fi
        if [[ `grep -m 1 -c '@Ignore' ${file}` -gt 0 ]]; then
            perl -0777 -pi -e 's/\@Ignore/\@Disabled/g' $file
        fi

        # Replace @RunWith(SpringJUnit4ClassRunner.class) with 
		# @ExtendWith(SpringExtension.class).
        # Replace @RunWith(MockitoJUnitRunner.class) with 
		# @ExtendWith(MockitoExtension.class).
        if [[ `grep -m 1 -c 'org.junit.runner.RunWith' ${file}` -gt 0 ]]; then
            perl -0777 -pi -e 's/org\.junit\.runner\.RunWith/org.junit.jupiter.api.extension.ExtendWith/g' $file
        fi
        if [[ `grep -m 1 -c '@RunWith' ${file}` -gt 0 ]]; then
            perl -0777 -pi -e 's/\@RunWith/\@ExtendWith/g' $file
        fi
        if [[ `grep -m 1 -c 'org.springframework.test.context.junit4.SpringJUnit4ClassRunner' ${file}` -gt 0 ]]; then
            perl -0777 -pi -e 's/org\.springframework\.test\.context\.junit4\.SpringJUnit4ClassRunner/org.springframework.test.context.junit.jupiter.SpringExtension/g' $file
        fi
        if [[ `grep -m 1 -c 'SpringJUnit4ClassRunner' ${file}` -gt 0 ]]; then
            perl -0777 -pi -e 's/SpringJUnit4ClassRunner/SpringExtension/g' $file
        fi
        if [[ `grep -m 1 -c 'org.mockito.junit.MockitoJUnitRunner' ${file}` -gt 0 ]]; then
            perl -0777 -pi -e 's/org\.mockito\.junit\.MockitoJUnitRunner/org.mockito.junit.jupiter.MockitoExtension/g' $file
        fi
        if [[ `grep -m 1 -c 'MockitoJUnitRunner' ${file}` -gt 0 ]]; then
            perl -0777 -pi -e 's/MockitoJUnitRunner/MockitoExtension/g' $file
        fi

    fi

done

