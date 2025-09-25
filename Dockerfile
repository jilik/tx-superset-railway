FROM apache/superset:latest

USER root

RUN apt-get update && apt-get install -y \
    pkg-config \
    libmariadb-dev \
    unixodbc \
    unixodbc-dev \
    libpq-dev \
    gcc \
    g++ \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Передаем переменные окружения пользователю superset
ENV ADMIN_USERNAME=${ADMIN_USERNAME}
ENV ADMIN_EMAIL=${ADMIN_EMAIL}
ENV ADMIN_PASSWORD=${ADMIN_PASSWORD}
ENV SECRET_KEY=${SECRET_KEY}
ENV DATABASE_URL=${DATABASE_URL}

# Копируем скрипты и конфиги
COPY config/superset_init.sh /superset_init.sh
COPY config/superset_config.py /app/superset_config.py
RUN chmod +x /superset_init.sh
ENV SUPERSET_CONFIG_PATH=/app/superset_config.py

USER superset

# Устанавливаем драйверы прямо в venv пользователя superset
RUN /usr/bin/python3 -m pip install --user --no-cache-dir \
    psycopg2-binary \
    pymongo \
    pymssql \
    pyodbc \
    mysqlclient

ENTRYPOINT ["/superset_init.sh"]