# JUnit Converters

## Convert JUnit 3 code into JUnit 4

The `junit3ToJUnit4.zsh` script is not perfect, but it goes a long way
towards dealing with the most common problems.


## Known Limitations

Does not address calls to:

```
junit.framework.TestSuite.addTestSuite(clazz);
```

For these you need to use `@RunWith(Suite.class)`.
