FROM minio/mc:RELEASE.2024-11-05T11-29-45Z AS mc

FROM python:3.13.1-alpine

# hadolint ignore=DL3018
RUN apk add --no-cache bash yq

# Install Ansible and required collections
# hadolint ignore=DL3013
RUN pip install ansible boto3 --no-cache-dir && \
    ansible-galaxy collection install amazon.aws ansible.posix

COPY --from=mc /usr/bin/mc /usr/bin/mc
RUN mc --version

WORKDIR /ansible

# Copy Ansible files
COPY ansible.cfg ./
COPY roles ./roles
COPY playbooks ./playbooks

# This directory should be mounted by the user
COPY tests/inventory.ini /config/inventory.ini

# Run playbook
ENTRYPOINT ["ansible-playbook", "playbooks/main.yml"]
