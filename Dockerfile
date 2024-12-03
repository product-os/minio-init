FROM minio/mc:RELEASE.2024-11-05T11-29-45Z AS mc

FROM python:3.13.0-alpine

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
COPY inventory.ini ansible.cfg ./
COPY roles ./roles
COPY playbooks ./playbooks

# Run playbook
ENTRYPOINT ["ansible-playbook", "playbooks/main.yml"]
