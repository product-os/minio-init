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
Create a configuration file and mount it when running the container:

```yaml
# config.yml example
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
docker run -v $(pwd)/config.yml:/ansible/config.yml \
          -e MINIO_ENDPOINT=your-minio-server \
          -e MINIO_ACCESS_KEY=your-access-key \
          -e MINIO_SECRET_KEY=your-secret-key \
          minio-init
```

## Project Structure

```text
.
├── Dockerfile              # Container definition
├── ansible.cfg            # Ansible configuration
├── test.yml              # Main playbook
└── roles
    └── minio-init
        ├── tasks
        │   ├── main.yml
        │   ├── access_keys.yml
        │   ├── users.yml
        │   └── buckets.yml
        └── defaults
            └── main.yml
```

## Environment Variables

| Variable         | Description          | Required |
| ---------------- | -------------------- | -------- |
| MINIO_ENDPOINT   | MinIO server address | Yes      |
| MINIO_ACCESS_KEY | Admin access key     | Yes      |
| MINIO_SECRET_KEY | Admin secret key     | Yes      |

## Development

To run the playbook in check mode:

```bash
docker run --rm minio-init ansible-playbook test.yml --check
```

## License

Copyright 2024 Balena Ltd.

Licensed under the Apache License, Version 2.0.
See [LICENSE](./LICENSE) for the full license text.
