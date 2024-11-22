#!/bin/bash

# Check if ELASTIC_URL environment variable is set
if [ -z "$ELASTIC_URL" ]; then
    echo "ELASTIC_URL environment variable is not set."
    exit 1
fi

if [ -z "$PROTOCOL" ]; then
  # Store protocol in PROTOCOL variable
  if [[ "$ELASTIC_URL" == https://* ]]; then
      PROTOCOL="https"
  elif [[ "$ELASTIC_URL" == http://* ]]; then
      PROTOCOL="http"
  else
      echo "Protocol not found in ELASTIC_URL. Using unsafe protocol (http)."
      PROTOCOL="http"
  fi

  # Remove http:// or https:// from ELASTIC_URL if present
  ELASTIC_URL_CLEAN=$(echo "$ELASTIC_URL" | sed -e 's/^http[s]*:\/\///')

  # Set ELASTIC_URL to cleaned value
  export ELASTIC_URL="$ELASTIC_URL_CLEAN"
  export PROTOCOL
fi

if [ "$DEBUG" == "true" ]; then
    echo "DEBUG mode enabled. Adding additional args for elasticsearch_exporter..."
    sed -i '/command=\/bin\/elasticsearch_exporter/ s/$/ --collector.clustersettings --es.aliases --collector.snapshots --es.data_stream/' /etc/supervisor/conf.d/supervisord.conf
fi

echo "Initializing monitoring instance..."

/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf