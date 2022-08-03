FROM jenkins/jenkins:2.336-jdk11
USER root

# Install node 16.x and yarn
RUN apt-get update && apt-get -y install \
  curl software-properties-common
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - 
RUN apt-get install -y nodejs; npm i -g yarn

# Install docker
# TODO: I guess I don't need to install docker
# RUN apt-get update && apt-get install -y lsb-release
# RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
#   https://download.docker.com/linux/debian/gpg
# RUN echo "deb [arch=$(dpkg --print-architecture) \
#   signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
#   https://download.docker.com/linux/debian \
#   $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
# RUN apt-get update && apt-get install -y docker-ce-cli

# Install docker-compose
RUN curl -L https://github.com/docker/compose/releases/download/1.25.5/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

# Install nano and jq
RUN apt-get install -y nano \
  && apt-get install -y jq \
  && apt-get install -y zip \
  && apt-get install -y wget \
  && apt-get install -y mc 

# Install Build Essentials
RUN apt-get update && apt-get install build-essential -y && apt-get install file -y && apt-get install apt-utils -y

# Give jenkins access to docker
# RUN groupadd -g 112 docker
RUN groupadd docker
RUN gpasswd -a jenkins docker
RUN usermod -aG docker jenkins

USER jenkins

# Add blueocean
RUN jenkins-plugin-cli --plugins "blueocean:1.25.2 docker-workflow:1.28"
