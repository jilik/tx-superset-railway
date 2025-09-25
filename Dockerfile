FROM apache/superset:latest

USER root

# Устанавливаем нужные системные пакеты
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    unixodbc \
    unixodbc-dev \
    libpq-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Python пакеты
RUN pip install --upgrade pip && pip install \
    pymysql \
    pymongo \
    pymssql \
    pyodbc

ENV ADMIN_USERNAME $ADMIN_USERNAME
ENV ADMIN_EMAIL $ADMIN_EMAIL
ENV ADMIN_PASSWORD $ADMIN_PASSWORD
ENV SECRET_KEY $SECRET_KEY
ENV SUPERSET_CONFIG_PATH /app/superset_config.py

COPY /config/superset_init.sh ./superset_init.sh
RUN chmod +x ./superset_init.sh

COPY /config/superset_config.py /app/

USER superset
ENTRYPOINT [ "./superset_init.sh" ]