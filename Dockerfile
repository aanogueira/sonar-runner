FROM adoptopenjdk:11-jre-hotspot AS builder

ARG SONAR_REVAMP_HOST_URL
ENV SONAR_HOST_URL=${SONAR_REVAMP_HOST_URL}

ARG SONAR_REVAMP_TOKEN
ENV SONAR_TOKEN=${SONAR_REVAMP_TOKEN}

WORKDIR /root

COPY scan.sh /root/scan.sh

COPY NuGet.Config /root/.nuget/NuGet/NuGet.Config

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get dist-upgrade -y && \
    apt-get -y autoremove && \
    apt-get clean && \
    apt-get install -y unzip && \
    apt-get install -y shellcheck && \
    apt-get install -y nodejs && \
    curl https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.5.0.2216-linux.zip -L -o sonar.zip && \
    unzip sonar.zip && \
    rm -f sonar.zip && \
    ln -s `pwd`/sonar-scanner-4.5.0.2216-linux/bin/sonar-scanner /bin/sonar-scanner && \
    ln -s /root/scan.sh /bin/scan

RUN apt-get install -y apt-transport-https wget vim && \
    wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    apt-get update && \
    apt-get install -y dotnet-sdk-3.1 && \
    dotnet tool install --global dotnet-sonarscanner --version 4.10.0 && \
    dotnet tool install --global coverlet.console --version 1.7.2 && \
    rm packages-microsoft-prod.deb

ENV DOTNET_CLI_TELEMETRY_OPTOUT=true

ENV PATH="${PATH}:/root/.dotnet/tools"
