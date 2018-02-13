FROM resin/armv7hf-debian-qemu
ENV DEBIAN_FRONTEND noninteractive

RUN [ "cross-build-start" ]

RUN apt-get update && \
    apt-get install -yq \
            apt-transport-https \
            curl \
            git \
            wget
            
RUN curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - \
    && echo 'deb https://deb.nodesource.com/node_4.x jessie main' > /etc/apt/sources.list.d/nodesource.list \
    && echo 'deb-src https://deb.nodesource.com/node_4.x jessie main' >> /etc/apt/sources.list.d/nodesource.list \
    && apt-get update \
    && apt-get install -yq nodejs \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ARG MC_VERSION=unknown

RUN apt-get -qy update \
    && apt-get -qy dist-upgrade \
    && apt-get -qy install unzip \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir /meshcommander \
    && cd /meshcommander \
    && echo "MeshCommander version $MC_VERSION" > VERSION.TXT \
    && wget -q "http://info.meshcentral.com/downloads/mdtk/meshcommandersource.zip" \
    && unzip meshcommandersource.zip \
    && cd MeshCommander/NodeJS \
    && npm install

RUN sed -i -- 's/127.0.0.1/0.0.0.0/g' /meshcommander/MeshCommander/NodeJS/webserver.js

RUN [ "cross-build-end" ] 

EXPOSE 3000

WORKDIR /meshcommander/MeshCommander/NodeJS/
CMD ["node", "meshcommander.js"]
