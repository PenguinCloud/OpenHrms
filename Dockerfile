FROM code-dal1.penguintech.group:5050/ptg/standards/docker-ansible-image:stable
LABEL company="Penguin Tech Group LLC"
LABEL org.opencontainers.image.authors="info@penguintech.group"
LABEL license="GNU AGPL3"

# GET THE FILES WHERE WE NEED THEM!
COPY . /opt/manager/
WORKDIR /opt/manager

# UPDATE as needed
RUN apt update && apt dist-upgrade -y && apt auto-remove -y && apt clean -y

# PUT YER ARGS in here
ARG APP_TITLE="OpenHRMS"
ARG ODOO_REPO="https://github.com/odoo/odoo.git"
ARG ODOO_VERSION="15.0"
ARG OPENHRMS_REPO="https://github.com/CybroOdoo/OpenHRMS.git"
ARG OPENHRMS_VERSION="15.0"
ARG WKHTMLTOPDF_REPO="https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.focal_amd64.deb"

# BUILD IT!
RUN ansible-playbook build.yml -c local

# PUT YER ENVS in here
ENV DATABASE_HOST="postgresql"
ENV DATABASE_USER="openhrms"
ENV DATABASE_PASSWORD="password123"
ENV DATABASE_PORT="5432"
ENV ADMIN_PASSWORD="password"
# Switch to non-root user
# USER ptg-user

# Entrypoint time (aka runtime)
ENTRYPOINT ["/bin/bash","/opt/manager/entrypoint.sh"]
