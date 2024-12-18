# syntax=docker/dockerfile:1
# Dockerfile for combining multiple services
FROM ubuntu:latest
RUN apt-get update && apt-get install -y supervisor wget

# Prometheus
RUN wget https://github.com/prometheus/prometheus/releases/download/v2.49.1/prometheus-2.49.1.linux-amd64.tar.gz
RUN tar -xzf prometheus-2.49.1.linux-amd64.tar.gz
RUN mv prometheus-*/* /bin

# Config files for Prometheus
COPY ./prometheus.yml /etc/prometheus/prometheus.yml
COPY ./elasticsearch.rules.yml /etc/prometheus/elasticsearch.rules.yml

# Node Exporter
RUN wget https://github.com/prometheus/node_exporter/releases/download/v1.7.0/node_exporter-1.7.0.linux-amd64.tar.gz
RUN tar -xzf node_exporter-1.7.0.linux-amd64.tar.gz
RUN mv node_exporter-*/node_exporter /bin

# Grafana
RUN apt-get install -y apt-transport-https software-properties-common wget
RUN wget https://dl.grafana.com/enterprise/release/grafana-enterprise-10.3.1.linux-amd64.tar.gz
# RUN tar -zxvf /usr/sbin/grafana-enterprise-10.3.1.linux-amd64.tar.gz 
RUN tar -zxvf grafana-enterprise-10.3.1.linux-amd64.tar.gz
RUN cp grafana-*/bin/* /bin
RUN rm grafana-enterprise-10.3.1.linux-amd64.tar.gz

# Config files for Grafana
# Dashboards & provisioning
COPY config.ini /etc/grafana/
COPY ./provisioning/dashboards/all.yml /etc/grafana/provisioning/dashboards/
COPY ./provisioning/datasources/prometheus.yml /etc/grafana/provisioning/datasources/
COPY ./dashboards/* /var/lib/grafana/dashboards/

# Elasticsearch Exporter
RUN wget https://github.com/prometheus-community/elasticsearch_exporter/releases/download/v1.7.0/elasticsearch_exporter-1.7.0.linux-amd64.tar.gz
RUN tar -xzf elasticsearch_exporter-1.7.0.linux-amd64.tar.gz
RUN mv elasticsearch_exporter-*/elasticsearch_exporter /bin
RUN rm elasticsearch_exporter-1.7.0.linux-amd64.tar.gz
RUN rm -rf elasticsearch_exporter-1.7.0.linux-amd64

# Copy supervisord configuration file
COPY supervisord.conf /etc/supervisor/conf.d/

COPY run_instance.sh /bin

RUN chmod +x /bin/run_instance.sh

ENV DEBUG=false

EXPOSE 3000/tcp
EXPOSE 9090/tcp

# Start supervisord
CMD ["/bin/run_instance.sh"]