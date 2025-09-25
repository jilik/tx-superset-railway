FROM apache/superset:latest

USER root

RUN apt-get update && apt-get install -y \
    pkg-config \          # <- обязательно
    libmariadb-dev \
    unixodbc \
    unixodbc-dev \
    gcc \
    g++ \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# pip лучше обновить отдельно
RUN pip install --upgrade pip

# Python пакеты для баз данных
RUN pip install \
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