#!/bin/zsh

########################################################################
#
# Script for converting JUnit 3 code to JUnit 4 code on Mac OS X.
#
# This script does not deal with calls to:
#   junit.framework.TestSuite.addTestSuite(clazz);
#
########################################################################

for file in src/test/java/**/*.java; do

    # If the test class directly extends TestCase...
    if [[ `grep -m 1 -c "extends *TestCase" ${file}` -eq 1 ]]; then

        echo "Processing: ${file}\n"

        # Remove import of TestCase and add static import for Assert.*.
        perl -0777 -pi -e 's/import\s+junit.framework.TestCase;/import static org.junit.Assert.*;/' $file

        # Remove imports for Assert.
        perl -0777 -pi -e 's/import\s+(junit.framework|org.junit)\.Assert;//g' $file

        # Stop extending TestCase.
        perl -0777 -pi -e 's/\s+extends\s+TestCase//' ${file}

        # Remove obsolete calls to super constructors, but leave the constructors in place.
        perl -0777 -pi -e 's/[ \t]*super\([[:alpha:]]*\);\n//g' $file

        # Remove obsolete calls to super.setUp() and super.tearDown().
        perl -0777 -pi -e 's/[ \t]*super\.setUp\(\);\n//g' $file
        perl -0777 -pi -e 's/[ \t]*super\.tearDown\(\);\n//g' $file

        # Remove obsolete @Override declarations on setUp() and tearDown().
        perl -0777 -pi -e 's/[ \t]*\@Override\n\s+protected\s+void\s+setUp/\n\tprotected void setUp/g' $file
        perl -0777 -pi -e 's/[ \t]*\@Override\n\s+public\s+void\s+setUp/\n\tpublic void setUp/g' $file
        perl -0777 -pi -e 's/[ \t]*\@Override\n\s+protected\s+void\s+tearDown/\n\tprotected void tearDown/g' $file
        perl -0777 -pi -e 's/[ \t]*\@Override\n\s+public\s+void\s+tearDown/\n\tpublic void tearDown/g' $file

        # Add @Test/@Before/@After only if they are not present in the class already.

        if [[ `grep -m 1 -c "@Test" ${file}` -eq 0 ]]; then
            perl -0777 -pi -e 's/[ \t]*public\s+void\s+test(\w)/\t\@Test\n\tpublic void \L$1/g' $file
        fi

        if [[ `grep -m 1 -c "@Before" ${file}` -eq 0 ]]; then
            perl -0777 -pi -e 's/[ \t]*(protected|public)[ \t]+void[ \t]+setUp\(\)/\t\@Before\n\tpublic void setUp()/' $file
        fi

        if [[ `grep -m 1 -c "@After" ${file}` -eq 0 ]]; then
            perl -0777 -pi -e 's/[ \t]*(protected|public)[ \t]+void[ \t]+tearDown\(\)/\t\@After\n\tpublic void tearDown()/' $file
        fi

        # Import @After if necessary.
        if [[ `grep -m 1 -c @After $file` -eq 1 && `grep -m 1 -c 'import org.junit.After;' $file` -eq 0 ]]; then
            perl -0777 -pi -e 's/(package\s+.+;)/$1\n\nimport org.junit.After;/' $file
        fi

        # Import @Before if necessary.
        if [[ `grep -m 1 -c @Before $file` -eq 1 && `grep -m 1 -c 'import org.junit.Before;' $file` -eq 0 ]]; then
            perl -0777 -pi -e 's/(package\s+.+;)/$1\n\nimport org.junit.Before;/' $file
        fi

        # Import @Test if necessary.
        if [[ `grep -m 1 -c '@Test' $file` -eq 1 && `grep -m 1 -c 'import org.junit.Test;' $file` -eq 0 ]]; then
            perl -0777 -pi -e 's/(package\s+.+;)/$1\n\nimport org.junit.Test;/' $file
        fi

    fi

    # Migrate from AssertionFailedError to java.lang.AssertionError.
    perl -0777 -pi -e 's/import\s+junit.framework.AssertionFailedError;//' $file
    perl -0777 -pi -e 's/(junit.framework.)?AssertionFailedError/AssertionError/g' $file

    ### Change any remaining old imports to the JUnit 4 package name.
    perl -0777 -pi -e 's/import\s+junit.framework./import org.junit./' $file

done
