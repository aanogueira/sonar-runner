# Sonar Runner

Runner used in pipelines for scanning source code
and submit the results alongside with the code
unit tests report to the `SonarQube` application.

## Running locally

In order to run this locally you can simply run:

```shell
make
```

A new `Docker` image will be built spinning a SonarQube instance
with default credentials, a Postgres database as its backend and the sonar-runner.

> The is also a `adminer` available for database testing purposes.

Inside the [test](/test) folder we have six other ones:

| Folder           | Description                                               |
| ---------------- | --------------------------------------------------------- |
| **dotnet-nunit** | Dotnet project with testing (nunit) and report generated. |
| **dotnet-xunit** | Dotnet project with testing (xunit) and report generated. |
| **go**           | Golang project with testing and report generated.         |
| **js**           | JavaScript project with testing and report generated.     |
| **py**           | Python project with testing and report generated.         |
| **scanners**     | Modified scripts of [scan.sh](scan.sh) for local testing. |

For the code coverage of each example to be imported to the sonar,
each test program needs to be build/compiled/run tests.

### Generate code coverage

Dotnet is executed through the `sonar-runner`, there is no need to run locally.

Golang:

```sh
cd test/go
go test -tags musl ./... -coverprofile=coverage.out
```

Java:

```sh
cd test/java
mvn clean verify
```

JavaScript:

```sh
cd test/js
npm install && \
  npm test -- --watchAll=false --passWithNoTests
```

Python:

```sh
cd test/py
pip install -r requirements.txt && \
  nosetests --with-coverage  --cover-branches -v test*.py --cover-xml
```

## Language Specific Configuration

Each programming language has it's own characteristics. Because of that there is a custom sonar configuration file (_sonar-project.properties_) inside each language folder.

## Project Configuration

Most of the of the Sonar capabilities are available _out of the box_ without much configuration on the project side.
There is an exception, which is the code coverage.

Code coverage needs to be done through language specific code analysis, for instance,
[Jacoco](https://www.jacoco.org/jacoco/) (for Java). The library analyses the code and generated a report that
can be then imported and displayed on the SonarQube project page.

Below is the additional configuration needed in order to retrieve the code coverage statistics.

### Dotnet Requirements

For the Dotnet projects, since we are using [coverlet](https://github.com/coverlet-coverage/coverlet)
in order to extract code coverage from our projects, we'll need to add a dependency to our `.csproj` file:

```sh
dotnet add package coverlet.msbuild
```

Once we build our project, this will generate a report containing the information code coverage of
our unit tests.

> Validated with [NUnit](https://github.com/nunit/nunit) and [xUnit](https://github.com/xunit/xunit) testing frameworks.

### Go Requirements

For the Go we don't need any special configuration. The only thing we need is to simply generate an report, like:

```sh
go test -tags musl ./... -coverprofile=coverage.out
```

Once we build our project, this will generate a report containing the information code coverage of
our unit tests.

### Java Requirements

Like we said in the example before, on the [Language Specific Configuration](sonarqube.html#language-specific-configuration)
section, in order to extract the code coverage from Java projects, we need to include the
[Jacoco](https://www.jacoco.org/jacoco/) Library.

To do it so, we simply need to include it in the `pom.xml` file of the project:

```xml
...
  <build>
    <plugins>
      ...
      <plugin>
        <groupId>org.jacoco</groupId>
        <artifactId>jacoco-maven-plugin</artifactId>
        <version>0.8.6</version>
        <executions>
          <execution>
            <goals>
              <goal>prepare-agent</goal>
            </goals>
          </execution>
          <execution>
            <id>jacoco-report</id>
            <phase>test</phase>
            <goals>
              <goal>report</goal>
            </goals>
          </execution>
        </executions>
      </plugin>
      ...
    </plugins>
  </build>
...
```

Once we build our project, this will generate a report containing the information code coverage of
our unit tests.

### JavaScript Requirements

To extract SonarQube compatible reports we need to include the [Jest](https://jestjs.io/) Testing Framework.

To dot it so, we simply need to include it in the `package.json` file fo the project:

```json
{
  ...
  "scripts": {
    "test": "jest"
  },
  "jest": {
    "collectCoverage": true,
    "collectCoverageFrom": [
      "src/**/*.js",
      "!**/node_modules/**"
    ],
    "testResultsProcessor": "jest-sonar-reporter"
  },
  "jestSonar": {
    "sonar56x": true,
    "reportPath": "coverage",
    "reportFile": "report.xml",
    "indent": 4
  },
  "devDependencies": {
    "jest": "^26.6.1",
    "jest-sonar-reporter": "^2.0.0"
  },
  ...
}
```

Once we build our project, this will generate a report containing the information code coverage of
our unit tests.

### Python Requirements

For Python wee need to do some changes in the way we test our project. First we need to add two packages:

- [coverage](https://pypi.org/project/coverage/) -> Code coverage testing for Python
- [nose](https://pypi.org/project/nose/) -> Extends the test loading and running features of unittest

Once we have both of the dependdencies, we can simply run:

```sh
nosetests --with-coverage  --cover-branches -v test*.py --cover-xml
```

> `test*.py` are our unittest files.

Once we build our project, this will generate a report containing the information code coverage of
our unit tests.
