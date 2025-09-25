FROM apache/superset:latest

USER root

# Системные зависимости для PostgreSQL
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Установка psycopg2-binary в глобальное окружение Superset
RUN pip install --upgrade pip psycopg2-binary

# Переменные окружения для админа (можно передавать при запуске)
ENV ADMIN_USERNAME=$ADMIN_USERNAME
ENV ADMIN_EMAIL=$ADMIN_EMAIL
ENV ADMIN_PASSWORD=$ADMIN_PASSWORD
ENV SECRET_KEY=$SECRET_KEY

# Копируем init скрипт и делаем его исполняемым
COPY ./config/superset_init.sh /app/superset_init.sh
RUN chmod +x /app/superset_init.sh

# Копируем Superset конфиг
COPY ./config/superset_config.py /app/superset_config.py
ENV SUPERSET_CONFIG_PATH=/app/superset_config.py

USER superset

ENTRYPOINT ["/app/superset_init.sh"]