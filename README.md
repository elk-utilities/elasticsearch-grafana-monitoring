# Elasticsearch Grafana Monitoring

This project sets up a monitoring solution for Elasticsearch using Prometheus and Grafana within a Docker container. It includes configurations for Prometheus, Grafana, Node Exporter, and the Elasticsearch Exporter.

## Prerequisites

Before you begin, make sure you have [Docker](https://docs.docker.com/get-docker/) installed on your system.

## Usage

1. Clone this repository:

```bash
git clone https://github.com/elk-utilities/elasticsearch-grafana-monitoring.git
cd elasticsearch-grafana-monitoring

# You can build the docker image without copying the entire repository to your 
# local machine
```

2. Build the docker image for usage later
```bash
docker build -t elasticsearch-grafana-monitoring .

# Or build the image from the remote repository

docker build -t elasticsearch-grafana-monitoring https://github.com/elk-utilities/elasticsearch-grafana-monitoring.git
```
Edit the .env file with your Elasticsearch username, password, and URL.

3. Run the monitoring stack using Docker:
```bash
docker run -e ELASTIC_USER=your_username \
-e ELASTIC_PASSWORD=your_password \
-e ELASTIC_URL=https://your-elasticsearch-url \
--name your_monitoring_instance_name \
-p 3000:3000 \
elasticsearch-grafana-monitoring
```
This will start Prometheus, Grafana, Node Exporter, and Elasticsearch Exporter containers.

4. Access Grafana at http://localhost:3000 and log in using the default credentials (admin/admin).

5. Access the already imported dashboards!

## Project Structure

- **prometheus.yml**: Configuration file for Prometheus.
- **elasticsearch.rules.yml**: Rule file for Prometheus alerting.
- **config.ini**: Grafana configuration file.
- **provisioning**: Grafana provisioning directory containing data source and dashboard configurations.
- **dashboards**: Folder containing dashboards imported from [huynhsamha/grafana-dashboards-elasticsearch](https://github.com/huynhsamha/grafana-dashboards-elasticsearch/tree/master).

## Prometheus Targets

- **Prometheus**: [http://localhost:9090](http://localhost:9090)
- **Node Exporter**: [http://localhost:9100](http://localhost:9100)
- **Elasticsearch Exporter**: [http://localhost:9114](http://localhost:9114)

## Alerts

- **ElasticsearchTooFewNodesRunning**: Alerts if the number of Elasticsearch nodes is less than 3 for 5 minutes.
- **ElasticsearchHeapTooHigh**: Alerts if the heap usage is over 90% for 15 minutes.

## Customization

Feel free to customize configurations based on your requirements. Refer to the individual configuration files for more details.

## Notes

- Ensure that your Elasticsearch instance is accessible from the specified URL in the `.env` file.

## Acknowledgments

- This project uses images from the following repositories:
  - [Prometheus](https://hub.docker.com/r/prom/prometheus)
  - [Node Exporter](https://hub.docker.com/r/prom/node-exporter)
  - [Grafana Enterprise](https://hub.docker.com/r/grafana/grafana-enterprise)
  - [Elasticsearch Exporter](https://quay.io/prometheuscommunity/elasticsearch-exporter)
  - Dashboard configurations were taken from [huynhsamha/grafana-dashboards-elasticsearch](https://github.com/huynhsamha/grafana-dashboards-elasticsearch/tree/master).