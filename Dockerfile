FROM apache/superset:latest

USER root

# Устанавливаем все системные зависимости для драйверов
RUN apt-get update && apt-get install -y \
    pkg-config libmariadb-dev unixodbc unixodbc-dev libpq-dev gcc g++ \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Копируем конфиги
COPY config/superset_config.py /app/superset_config.py
COPY config/superset_init.sh /superset_init.sh
RUN chmod +x /superset_init.sh

# Ставим все python-зависимости глобально
RUN pip install --no-cache-dir \
    psycopg2-binary pymongo pymssql pyodbc mysqlclient

ENV SUPERSET_CONFIG_PATH=/app/superset_config.py
ENV ADMIN_USERNAME=${ADMIN_USERNAME}
ENV ADMIN_EMAIL=${ADMIN_EMAIL}
ENV ADMIN_PASSWORD=${ADMIN_PASSWORD}
ENV SECRET_KEY=${SECRET_KEY}
ENV DATABASE_URL=${DATABASE_URL}

USER superset

ENTRYPOINT ["/superset_init.sh"]