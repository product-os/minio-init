# minio-init

Containerized Ansible role for automated MinIO server initialization and configuration.

## Features

- Automated MinIO server configuration using Ansible
- User and access key management
- Bucket creation and configuration
- Runs in a containerized environment
- Uses official MinIO client (mc) for operations

## Requirements

- Docker
- MinIO server instance
- Network connectivity to MinIO server

## Usage

1. Build the container:

   ```bash
   docker build -t minio-init .
   ```

2. Run with required environment variables:

   ```bash
   docker run -e MINIO_ENDPOINT=your-minio-server \
           -e MINIO_ACCESS_KEY=your-access-key \
           -e MINIO_SECRET_KEY=your-secret-key \
           minio-init
   ```

## Configuration

The role behavior can be customized through Ansible variables.
Create an inventory directory or file and mount it when running the container.

```ini
# ./config/inventory.ini
[minio]
localhost ansible_connection=local
```

```yaml
# ./config/host_vars/minio.yml
minio_users:
  - name: service1
    access_key: access1
    secret_key: secret1

minio_buckets:
  - name: data-bucket
    access: private
```

Then run with your config:

```bash
docker run -v $(pwd)/config:/config \
          -e MINIO_ENDPOINT=your-minio-server \
          -e MINIO_ACCESS_KEY=your-access-key \
          -e MINIO_SECRET_KEY=your-secret-key \
          minio-init --inventory /config/inventory.ini
```

## Environment Variables

| Variable         | Description          | Required |
| ---------------- | -------------------- | -------- |
| MINIO_ENDPOINT   | MinIO server address | Yes      |
| MINIO_ACCESS_KEY | Admin access key     | Yes      |
| MINIO_SECRET_KEY | Admin secret key     | Yes      |

## Development

To run the playbook with the test configuration:

```bash
docker compose -f docker-compose.test.yml up sut --build
```

## License

Licensed under the Apache License, Version 2.0.
See [LICENSE](./LICENSE) for the full license text.
