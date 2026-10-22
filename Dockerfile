FROM pgsty/mc:RELEASE.2026-10-18T00-00-00Z@sha256:6ecdaec70bc5e8cf9d0e9a70c190f3beb1c83f11617ff4333f1fcd71ab1daf18 AS mc

FROM python:3.13.17-alpine@sha256:fa0bb0d0cd7c7d6cef30a69094d32ac2b71c7304c87c6107fec100e1ee4eda02

# hadolint ignore=DL3018
RUN apk add --no-cache bash

WORKDIR /ansible

# Install Ansible. The role uses only ansible.builtin modules, so
# ansible-core is enough and no collections are needed.
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY --from=mc /usr/bin/mc /usr/bin/mc
RUN mc --version

# Copy Ansible files
COPY ansible.cfg ./
COPY roles ./roles
COPY playbooks ./playbooks

# This directory should be mounted by the user
COPY tests/inventory.ini /config/inventory.ini

# Run playbook
ENTRYPOINT ["ansible-playbook", "playbooks/main.yml"]
