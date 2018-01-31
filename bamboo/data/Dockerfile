FROM cybertest/java:1.8

# Setup useful environment variables
ENV BAMBOO_HOME         /var/atlassian/application-data/bamboo
ENV BAMBOO_INSTALL      /opt/atlassian/bamboo
ENV BAMBOO_VERSION      6.0.3
ENV DOWNLOAD_URL        https://www.atlassian.com/software/bamboo/downloads/binary/atlassian-bamboo-${BAMBOO_VERSION}.tar.gz

ENV RUN_USER            root
ENV RUN_GROUP           root

RUN useradd -m ${RUN_USER}

RUN apt-get update  && apt-get install -qqy \
    apt-transport-https \
    lxc \
    iptables\
    libdevmapper1.02.1

# Install Atlassian Bamboo to the following location
RUN set -x \
    && apt-get update  \
    && apt-get install -y --no-install-recommends git ssh-client \
    && apt-get clean autoclean \
    && apt-get autoremove --yes \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/ \
    && mkdir -p                         "${BAMBOO_HOME}" \
    && chmod -R 700                     "${BAMBOO_HOME}" \
    && chown ${RUN_USER}:${RUN_GROUP}   "${BAMBOO_HOME}" \
    && mkdir -p                         "${BAMBOO_INSTALL}/conf" \
    && curl -Ls                         "${DOWNLOAD_URL}" | tar -xz --strip=1 -C "$BAMBOO_INSTALL" \
    && chmod -R 700                     "${BAMBOO_INSTALL}/conf" \
    && chmod -R 700                     "${BAMBOO_INSTALL}/logs" \
    && chmod -R 700                     "${BAMBOO_INSTALL}/temp" \
    && chmod -R 700                     "${BAMBOO_INSTALL}/work" \
    && cd ${BAMBOO_INSTALL}/atlassian-bamboo/WEB-INF/lib \
    && curl -SLO "https://gist.github.com/TommyLau/8a5ce4629d027f7884e6/raw/9bc3df0e1134c0a290665bdbec041a847a903cef/atlassian-extras-decoder-v2-3.3.0.jar" \
    && cd ../atlassian-bundled-plugins/ \
    && curl -SLO "https://gist.github.com/TommyLau/8a5ce4629d027f7884e6/raw/267b3e3c33e7c05b3079beaae4cc9248bf496291/atlassian-universal-plugin-manager-plugin-2.21.jar" \
    && chown -R ${RUN_USER}:${RUN_GROUP} ${BAMBOO_INSTALL} \
    && echo "bamboo.home=${BAMBOO_HOME}" > ${BAMBOO_INSTALL}/atlassian-bamboo/WEB-INF/classes/bamboo-init.properties \
    && mv ${BAMBOO_INSTALL}/atlassian-bamboo/WEB-INF/lib/javax.mail-*.jar ${BAMBOO_INSTALL}/lib \
    && curl -Ls "https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.40.tar.gz" | tar -xz --directory "${BAMBOO_INSTALL}/lib" --strip-components=1 --no-same-owner "mysql-connector-java-5.1.40/mysql-connector-java-5.1.40-bin.jar"


RUN apt-get update  \
    && apt-get install -y --no-install-recommends python-dev python-pip libjpeg8-dev nano openssl\
    mysql-client libmysqlclient-dev libxslt-dev build-essential libssl-dev libffi-dev libncurses5-dev  \
    apt-utils gcc g++-5 \
    && pip install --upgrade pip setuptools virtualenv 

RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update \
    && ACCEPT_EULA=Y apt-get install -y msodbcsql unixodbc-dev 
    
RUN apt-get update && ACCEPT_EULA=Y apt-get install -y mssql-tools
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
RUN /bin/bash -c "source ~/.bashrc"    

RUN apt-get install -y locales \
    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen

USER ${RUN_USER}:${RUN_GROUP}

# Expose default HTTP connector port.
EXPOSE 8085

# Agent Port
EXPOSE 54663

# Set volume mount points for installation and home directory. Changes to the
# home directory needs to be persisted as well as parts of the installation
# directory due to eg. logs.
VOLUME ["${BAMBOO_INSTALL}", "${BAMBOO_HOME}"]

# Set the default working directory as the Bamboo installation directory.
WORKDIR ${BAMBOO_INSTALL}

# Run in foreground
CMD ["./bin/start-bamboo.sh", "-fg"]
