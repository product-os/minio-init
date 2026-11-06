FROM pgsty/mc:RELEASE.2026-10-18T00-00-00Z@sha256:6ecdaec70bc5e8cf9d0e9a70c190f3beb1c83f11617ff4333f1fcd71ab1daf18 AS mc

FROM python:3.15.2-alpine@sha256:a0f2e268f2ce8f3709611a90054ec6a8ae31f6251f5896b8648b9bb99835e30a

# hadolint ignore=DL3018
RUN apk add --no-cache bash

WORKDIR /ansible

# Install Ansible. The role uses only ansible.builtin modules, but user
# config may call community.general lookups such as random_string.
COPY requirements.txt requirements.yml ./
RUN pip install --no-cache-dir -r requirements.txt && \
    ansible-galaxy collection install -r requirements.yml -p /ansible/collections

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
