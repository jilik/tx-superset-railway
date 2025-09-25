FROM apache/superset:latest

USER root

# Устанавливаем зависимости
RUN apt-get update && apt-get install -y \
    libmariadb-dev \
    unixodbc \
    unixodbc-dev \
    gcc \
    g++ \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Python пакеты для подключения к базам
RUN pip install --upgrade pip && pip install \
    mysqlclient \
    pymongo \
    pymssql \
    pyodbc

# ENV переменные для админа
ENV ADMIN_USERNAME $ADMIN_USERNAME
ENV ADMIN_EMAIL $ADMIN_EMAIL
ENV ADMIN_PASSWORD $ADMIN_PASSWORD
ENV SECRET_KEY $SECRET_KEY

COPY /config/superset_init.sh ./superset_init.sh
RUN chmod +x ./superset_init.sh

COPY /config/superset_config.py /app/
ENV SUPERSET_CONFIG_PATH /app/superset_config.py

USER superset

ENTRYPOINT ["./superset_init.sh"]