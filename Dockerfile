FROM code-dal1.penguintech.group:5050/ptg/standards/docker-ansible-image
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
ARG WKHTMLTOPDF_REPO="https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.focal_amd64.deb"

# BUILD IT!
RUN ansible-playbook build.yml -c local

# PUT YER ENVS in here
ENV DATABASE_NAME="mydb"
ENV DATABASE_HOST="mydb"
ENV DATABASE_USER="odoo"
ENV DATABASE_PASSWORD="password123"
ENV DATABASE_PORT="5432"

# Switch to non-root user
USER ptg-user

EXPOSE 8069
# Entrypoint time (aka runtime)
ENTRYPOINT ["/bin/bash","/opt/manager/entrypoint.sh"]
