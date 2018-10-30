FROM ubuntu:16.04

RUN apt-get update && apt-get install -y \
    automake \
    build-essential \
    checkinstall \
    libavcodec-dev \
    libavutil-dev \
    libcairo2-dev \
    libfreerdp-dev \
    libossp-uuid-dev \
    libpango1.0-dev \
    libpng12-dev \
    libpulse-dev \
    libssh2-1-dev \
    libssl-dev \
    libswscale-dev \
    libtelnet-dev \
    libvncserver-dev \
    libvorbis-dev \
    libwebp-dev \
    man-db \
    tomcat7 \
    tomcat7-examples tomcat7-admin \
    wget \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 8080
VOLUME /etc/guacamole
VOLUME /file-transfer

ENV VERSION=0.9.14
WORKDIR /APP/bin/remote
RUN wget "http://archive.apache.org/dist/guacamole/${VERSION}/source/guacamole-server-${VERSION}.tar.gz" \
    && tar zxvf guacamole-server-${VERSION}.tar.gz

#COPY en_gb_qwerty.keymap /APP/bin/remote/guacamole-server-${VERSION}/src/protocols/rdp/keymaps/en_gb_qwerty.keymap

RUN cd /APP/bin/remote/guacamole-server-${VERSION}/src/protocols/rdp \
    && cd /APP/bin/remote/guacamole-server-${VERSION} \
    && ./configure --with-init-dir=/etc/init.d \
    && make \
    && make install \
    && ldconfig  \
    && mkdir /usr/lib/x86_64-linux-gnu/freerdp \
    && ln -s /usr/local/lib/freerdp/*.so /usr/lib/x86_64-linux-gnu/freerdp/. \
    && cd /APP/bin/remote \
    && wget http://archive.apache.org/dist/guacamole/${VERSION}/binary/guacamole-${VERSION}.war \
    && ln -s /APP/bin/remote/guacamole-${VERSION}.war /var/lib/tomcat7/webapps/remote.war \
    && echo "GUACAMOLE_HOME=/etc/guacamole" >> /etc/default/tomcat7 \
    && chown tomcat7:tomcat7 /file-transfer

COPY start.sh /tmp/start.sh

ENTRYPOINT ["/bin/bash"]
CMD ["/tmp/start.sh"]
