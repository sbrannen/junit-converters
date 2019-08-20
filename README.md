# JUnit Converters

Conversion scripts and tools to assist with the migration from
one version of JUnit to a newer JUnit version.

## Convert JUnit 3 to JUnit 4

The `junit3ToJUnit4.zsh` script in this repository is not perfect,
but it goes a long way towards dealing with the most common problems.

### Known Limitations

Does not address calls to:

```
junit.framework.TestSuite.addTestSuite(clazz);
```

For these you need to use `@RunWith(Suite.class)`.

## Convert JUnit 4 to JUnit Jupiter

The `junit4ToJUnitJupiter.zsh` script in this repository helps
with automatically modifying imports and annotation usage but
does not assist with migrating assertions, rules, parameterized
tests, or use of `@FixMethodOrder`. The script also does not
migrate the `exception` and `timeout` attributes of JUnit 4's
`@Test` annotation.

See also: https://github.com/junit-pioneer/convert-junit4-to-junit5
