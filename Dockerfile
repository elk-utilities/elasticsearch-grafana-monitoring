# syntax=docker/dockerfile:1
# Dockerfile for combining multiple services
FROM ubuntu:latest
RUN apt-get update && apt-get install -y supervisor wget

# Prometheus
RUN wget https://github.com/prometheus/prometheus/releases/download/v2.49.1/prometheus-2.49.1.linux-amd64.tar.gz
RUN tar -xzf prometheus-2.49.1.linux-amd64.tar.gz
RUN mv prometheus-*/* /bin

RUN wget https://github.com/EdRamos12/elasticsearch-grafana-monitoring/raw/master/prometheus.yml -P /etc/prometheus
RUN wget https://github.com/EdRamos12/elasticsearch-grafana-monitoring/raw/master/elasticsearch.rules.yml -P /etc/prometheus

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

RUN wget https://github.com/EdRamos12/elasticsearch-grafana-monitoring/raw/master/config.ini -P /etc/grafana/
RUN wget https://github.com/EdRamos12/elasticsearch-grafana-monitoring/raw/master/provisioning/dashboards/all.yml -P /etc/grafana/provisioning/dashboards
RUN wget https://github.com/EdRamos12/elasticsearch-grafana-monitoring/raw/master/provisioning/datasources/prometheus.yml -P /etc/grafana/provisioning/datasources
RUN wget https://github.com/EdRamos12/elasticsearch-grafana-monitoring/raw/master/dashboards/es-history-stats-dashboard.json -P /var/lib/grafana/dashboards
RUN wget https://github.com/EdRamos12/elasticsearch-grafana-monitoring/raw/master/dashboards/es-index-stats-dashboard.json -P /var/lib/grafana/dashboards
RUN wget https://github.com/EdRamos12/elasticsearch-grafana-monitoring/raw/master/dashboards/es-node-index-dashboard.json -P /var/lib/grafana/dashboards
RUN wget https://github.com/EdRamos12/elasticsearch-grafana-monitoring/raw/master/dashboards/es-cluster-dashboard.json -P /var/lib/grafana/dashboards

# Elasticsearch Exporter
RUN wget https://github.com/prometheus-community/elasticsearch_exporter/releases/download/v1.7.0/elasticsearch_exporter-1.7.0.linux-amd64.tar.gz
RUN tar -xzf elasticsearch_exporter-1.7.0.linux-amd64.tar.gz
RUN mv elasticsearch_exporter-*/elasticsearch_exporter /bin

# Copy supervisord configuration file
# RUN wget https://github.com/EdRamos12/elasticsearch-grafana-monitoring/raw/master/supervisord.conf -P /etc/supervisor/conf.d/

# debugging purposes
COPY supervisord.conf /etc/supervisor/conf.d/

EXPOSE 3000/tcp

# Start supervisord
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]