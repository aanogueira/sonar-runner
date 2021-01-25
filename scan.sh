#!/bin/bash

if [[ "${TECH_STACK}" = "dotnet" ]]; then
  # Cannot use sonar-project.properties files
  # "sonar-project.properties files are not understood by the SonarScanner for MSBuild."
  dotnet build-server shutdown

  dotnet sonarscanner begin \
    /k:"${CI_PROJECT_NAMESPACE}:${CI_PROJECT_NAME}" \
    /n:"${CI_PROJECT_TITLE}" \
    /v:"${RELEASE_VERSION}" \
    /d:sonar.host.url=${SONAR_HOST_URL} \
    /d:sonar.login=${SONAR_TOKEN}
    /d:sonar.links.homepage=${CI_PROJECT_URL} \
    /d:sonar.links.ci="${CI_PROJECT_URL}/pipelines" \
    /d:sonar.links.scm="${CI_PROJECT_URL}/tree/master" \
    /d:sonar.gitlab.commit_sha=${CI_BUILD_REF} \
    /d:sonar.gitlab.ref_name=${CI_BUILD_REF_NAME} \
    /d:sonar.sources.inclusions="**/**.cs" \
    /d:sonar.test.inclusions"=**/**test*.cs,**/**Test*.cs" \
    /d:sonar.coverage.exclusions="**/**Test*.cs,**/**test*.cs,**/**testresult*.xml,**/**opencover*.xml" \
    /d:sonar.cs.opencover.reportsPaths="/root/**/TestResults/coverage.opencover.xml" \
    /d:sonar.cs.vstest.reportsPaths="/root/**/TestResults/testresult.xml" \
    /d:sonar.coverage.dtdVerification=true \
    /d:sonar.test.exclusions="**/**testresult*.xml,**/**opencover*.xml"
  if [[ -z "${solution}" ]]; then
    dotnet build -o `pwd`/build -r debian-x64 --packages /cache/nuget/packages
    dotnet restore .
    coverlet . \
      --target "dotnet" \
      --targetargs "test . /p:CollectCoverage=true /p:CoverletOutputFormat=opencover --logger:trx;LogFileName=testresult.xml /p:CoverletOutput=TestResults/coverage.opencover.xml" \
      --format opencover \
      --output TestResults/ \
      --include-test-assembly
  else
    dotnet build -o `pwd`/build -r debian-x64 --packages /cache/nuget/packages ${solution}
    dotnet restore ${solution}
    coverlet . \
      --target "dotnet" \
      --targetargs "test ${solution} /p:CollectCoverage=true /p:CoverletOutputFormat=opencover --logger:trx;LogFileName=testresult.xml /p:CoverletOutput=TestResults/coverage.opencover.xml" \
      --format opencover \
      --output TestResults/ \
      --include-test-assembly
  fi
  dotnet sonarscanner end \
    /d:sonar.login=${SONAR_TOKEN}
else
  sonar-scanner \
    -Dsonar.host.url=${SONAR_HOST_URL} \
    -Dsonar.login=${SONAR_TOKEN} \
    -Dsonar.projectKey="${CI_PROJECT_NAMESPACE}:${CI_PROJECT_NAME}" \
    -Dsonar.projectName="${CI_PROJECT_TITLE}" \
    -Dsonar.projectVersion="${RELEASE_VERSION}" \
    -Dsonar.links.homepage=${CI_PROJECT_URL} \
    -Dsonar.links.ci="${CI_PROJECT_URL}/pipelines" \
    -Dsonar.links.scm="${CI_PROJECT_URL}/tree/master" \
    -Dsonar.gitlab.commit_sha=${CI_BUILD_REF} \
    -Dsonar.gitlab.ref_name=${CI_BUILD_REF_NAME}
fi
