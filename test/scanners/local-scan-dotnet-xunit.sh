#!/bin/bash

SONAR_HOST_URL='http://sonarqube:9000'
CI_PROJECT_NAMESPACE='test'
CI_PROJECT_NAME='Dotnet-Xunit'
CI_PROJECT_TITLE='Dotnet Xunit Test Project'
RELEASE_VERSION='1.0.1'
CI_PROJECT_URL='laptop.local'
CI_BUILD_REF='123456789'
CI_BUILD_REF_NAME='test-build'
USERNAME='admin'
PASSWORD='admin'

cd dotnet-xunit

# If the project has multiples .sln files
# solution=Project.sln

# Dotnet installed on image
# Can be run locally or inside the container
dotnet build-server shutdown

# Cannot use sonar-project.properties files
# "sonar-project.properties files are not understood by the SonarScanner for MSBuild."
dotnet sonarscanner begin \
  /k:"${CI_PROJECT_NAMESPACE}:${CI_PROJECT_NAME}" \
  /n:"${CI_PROJECT_TITLE}" \
  /v:"${RELEASE_VERSION}" \
  /d:sonar.host.url=${SONAR_HOST_URL} \
  /d:sonar.login=${USERNAME} \
  /d:sonar.password=${PASSWORD} \
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
  # Might need to change this locally to:
  # dotnet build -o `pwd`/build -r debian-x64 --packages /root/.nuget/package
  dotnet restore .
  coverlet . \
    --target "dotnet" \
    --targetargs "test . /p:CollectCoverage=true /p:CoverletOutputFormat=opencover --logger:trx;LogFileName=testresult.xml /p:CoverletOutput=TestResults\coverage.opencover.xml" \
    --format opencover \
    --output TestResults/ \
    --include-test-assembly
else
  dotnet build -o `pwd`/build -r debian-x64 --packages /cache/nuget/packages ${solution}
  # Might need to change this locally to:
  # dotnet build -o `pwd`/build -r debian-x64 --packages /root/.nuget/package ${solution}
  dotnet restore $solution
  coverlet . \
    --target "dotnet" \
    --targetargs "test ${solution} /p:CollectCoverage=true /p:CoverletOutputFormat=opencover --logger:trx;LogFileName=testresult.xml /p:CoverletOutput=TestResults\coverage.opencover.xml" \
    --format opencover \
    --output TestResults/ \
    --include-test-assembly
fi
dotnet sonarscanner end \
  /d:sonar.login=${USERNAME} \
  /d:sonar.password=${PASSWORD}
