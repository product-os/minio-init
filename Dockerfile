FROM pgsty/mc:RELEASE.2026-09-13T00-00-00Z@sha256:aa5cc1401b3e1ab482d215d5717e9e69b4f14970a3656f330ed20a549fe19020 AS mc

FROM python:3.13.1-alpine

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
