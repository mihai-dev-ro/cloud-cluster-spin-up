FROM mesosphere/spark:2.11.0-2.4.6-scala-2.11-hadoop-2.9

#ARG LIBMESOS_BUNDLE_URL="https://downloads.mesosphere.com/libmesos-bundle"
#ARG LIBMESOS_BUNDLE_VERSION="1.8-0"
#ARG LIBMESOS_BUNDLE_SHA256="cb81ae1211826afd4144f32fc30e6da6e122c85a5a8a3b13337c308dc2f6e69c"

ARG HOME=/root
ARG LIVY_GPG_KEYS_URL="https://www.apache.org/dist/incubator/livy/KEYS"
ARG LIVY_URL="https://mirrors.hostingromania.ro/apache.org/incubator/livy"
ARG LIVY_URL_SIGN="https://www.apache.org/dist/incubator/livy"
ARG LIVY_VERSION="0.7.0-incubating"

ARG MESOS_JAR_SHA1="0100b3535f8b070dc89af798bc009a3c5034ba27"
ARG MESOS_MAVEN_URL="https://repo1.maven.org/maven2/org/apache/mesos/mesos"
ARG MESOS_PROTOBUF_JAR_SHA1="b85fd83083855856520b8f57317fb1dc081f8613s"
ARG MESOS_VERSION="1.8.0"

# https://www.apache.org/dist/incubator/livy/0.7.0-incubating/apache-livy-0.7.0-incubating-bin.zip.asc

# removed line
# && gpg --verify "apache-livy-${LIVY_VERSION}-bin.zip.asc" "apache-livy-${LIVY_VERSION}-bin.zip" \
# && echo "${MESOS_JAR_SHA1} mesos-${MESOS_VERSION}.jar" | sha1sum -c - \
# && echo "${MESOS_PROTOBUF_JAR_SHA1} mesos-${MESOS_VERSION}-shaded-protobuf.jar" | sha1sum -c -

ENV HOME=${HOME:-"/root"}

RUN cd "${HOME}" \
    && curl --retry 3 -fsSL -O "${LIVY_URL}/${LIVY_VERSION}/apache-livy-${LIVY_VERSION}-bin.zip" \
    && curl --retry 3 -fsSL -O "${LIVY_URL_SIGN}/${LIVY_VERSION}/apache-livy-${LIVY_VERSION}-bin.zip.asc" \
    && curl --retry 3 -fsSL -O "${LIVY_GPG_KEYS_URL}" \
    && gpg --import KEYS \
    && gpg --verify --batch "apache-livy-${LIVY_VERSION}-bin.zip.asc" "apache-livy-${LIVY_VERSION}-bin.zip" \
    && unzip "apache-livy-${LIVY_VERSION}-bin.zip" \
    && rm -rf "apache-livy-${LIVY_VERSION}-bin.zip.asc" \
    && rm "apache-livy-${LIVY_VERSION}-bin.zip" \
    && mv "apache-livy-${LIVY_VERSION}-bin" livy \
    && mkdir -p livy/logs \
    && cd livy/jars \
    && curl --retry 3 -fsSL -O "${MESOS_MAVEN_URL}/${MESOS_VERSION}/mesos-${MESOS_VERSION}.jar" \  
    && curl --retry 3 -fsSL -O "${MESOS_MAVEN_URL}/${MESOS_VERSION}/mesos-${MESOS_VERSION}-shaded-protobuf.jar" 
    
COPY --chown="1000:100" log4j.properties "${HOME}/livy/conf/log4j.properties"
COPY --chown="1000:100" livy-mesos-dispatcher.conf "${HOME}/livy/conf/livy.conf"
COPY entrypoint.sh /opt/entrypoint.sh

# change the permision for the bash script
RUN chmod +x /opt/entrypoint.sh

# expose 8998/TCP (livy)
EXPOSE 8998 4040-4050 7001-7010

WORKDIR /
CMD [ "/opt/entrypoint.sh" ]
