FROM apache/superset:latest

USER root

# Устанавливаем системные зависимости
RUN apt-get update && apt-get install -y \
    pkg-config libmariadb-dev unixodbc unixodbc-dev libpq-dev gcc g++ \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Устанавливаем зависимости в виртуальное окружение Superset
RUN /app/.venv/bin/pip install --no-cache-dir \
    psycopg2-binary==2.9.9 \
    pymongo \
    pymssql \
    pyodbc \
    mysqlclient

# Копируем конфиги
COPY superset_config.py /app/superset_config.py
COPY superset_init.sh /superset_init.sh
RUN chmod +x /superset_init.sh

# Настройки окружения
ENV SUPERSET_CONFIG_PATH=/app/superset_config.py
ENV PYTHONPATH=/app

USER superset

# Экспозим порт для Railway
EXPOSE 8088

ENTRYPOINT ["/superset_init.sh"]