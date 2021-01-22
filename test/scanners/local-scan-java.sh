#!/bin/sh

SONAR_HOST_URL='http://sonarqube:9000'
CI_PROJECT_NAMESPACE='test'
CI_PROJECT_NAME='Java'
CI_PROJECT_TITLE='Java Test Project'
RELEASE_VERSION='1.0.1'
CI_PROJECT_URL='laptop.local'
CI_BUILD_REF='123456789'
CI_BUILD_REF_NAME='test-build'
USERNAME='admin'
PASSWORD='admin'

cd java

# Go not installed on image
# Needs to be run locally
# mvn clean verify

sonar-scanner -Dsonar.host.url=${SONAR_HOST_URL} \
    -Dsonar.login=${USERNAME} \
    -Dsonar.password=${PASSWORD} \
    -Dsonar.projectKey="${CI_PROJECT_NAMESPACE}:${CI_PROJECT_NAME}" \
    -Dsonar.projectName="${CI_PROJECT_TITLE}" \
    -Dsonar.projectVersion="${RELEASE_VERSION}" \
    -Dsonar.links.homepage=${CI_PROJECT_URL} \
    -Dsonar.links.ci="${CI_PROJECT_URL}/pipelines" \
    -Dsonar.links.scm="${CI_PROJECT_URL}/tree/master" \
    -Dsonar.gitlab.commit_sha=${CI_BUILD_REF} \
    -Dsonar.gitlab.ref_name=${CI_BUILD_REF_NAME}
