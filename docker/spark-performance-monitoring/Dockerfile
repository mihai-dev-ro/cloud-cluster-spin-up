FROM ubuntu:18.04

ENV INFLUXDB_VER="1.8.0"
ENV GRAFANA_VER="7.0.3"
ENV ARCH="amd64"

# install influxdb 
RUN set -ex && \
    apt-get update && \
    apt-get install -qq -y curl adduser libfontconfig1 && \
    curl -O https://dl.influxdata.com/influxdb/releases/influxdb_${INFLUXDB_VER}_${ARCH}.deb && \
    dpkg -i influxdb_${INFLUXDB_VER}_${ARCH}.deb && \
    rm -f influxdb_${INFLUXDB_VER}_${ARCH}.deb && \
    curl -O https://dl.grafana.com/oss/release/grafana_${GRAFANA_VER}_${ARCH}.deb && \
    dpkg -i grafana_${GRAFANA_VER}_${ARCH}.deb && \
    rm -f grafana_${GRAFANA_VER}_${ARCH}.deb

# copy the configs
COPY influxdb.conf /etc/influxdb/influxdb.conf
COPY --chown=grafana:grafana grafana_dashboards /var/lib/grafana/dashboards
COPY --chown=grafana:grafana grafana_datasource_influx.yaml /etc/grafana/provisioning/datasources/influx.yaml
COPY --chown=grafana:grafana grafana_dashboard_spark.yaml /etc/grafana/provisioning/dashboards/spark.yaml
COPY entrypoint.sh /opt/entrypoint.sh

# change the permision for the bash script
RUN chmod +x /opt/entrypoint.sh

# expose 2003/TCP (graphite), 8086/TCP (influxdb), 3000/TCP (grafana) 
EXPOSE 2003/tcp 8086/tcp 3000/tcp


WORKDIR /
CMD [ "/opt/entrypoint.sh" ]