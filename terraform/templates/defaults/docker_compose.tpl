version: "3.8"
services:
  mocked_server:
    image: ${mocked_server_image}
    ports:
      - "80:8080"
      - "443:443"
  sample_app:
    image: ${sample_app_image}
    ports:
      - "${sample_app_external_port}:${sample_app_listen_address_port}"
    environment:
      LISTEN_ADDRESS: ${listen_address}
      OTEL_RESOURCE_ATTRIBUTES: ${otel_resource_attributes}
      INSTANCE_ID: ${testing_id}
      OTEL_EXPORTER_OTLP_ENDPOINT: ${grpc_endpoint}
      AWS_XRAY_DAEMON_ADDRESS: ${udp_endpoint}
      AWS_REGION: ${region}

    healthcheck:
      test: ["CMD", "curl", "-f", "http://127.0.0.1:${sample_app_listen_address_port}/"]
      interval: 5s
      timeout: 10s
      retries: 3
      start_period: 10s