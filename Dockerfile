FROM apache/superset:latest

USER root

# Системные зависимости для PostgreSQL
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Установка psycopg2-бinary глобально (Superset его увидит)
RUN pip install --upgrade pip psycopg2-binary

# Переменные окружения для админа
ENV ADMIN_USERNAME=admin
ENV ADMIN_EMAIL=admin@example.com
ENV ADMIN_PASSWORD=admin
ENV SECRET_KEY=mysecret

# Копируем init скрипт и делаем его исполняемым
COPY ./config/superset_init.sh /app/superset_init.sh
RUN chmod +x /app/superset_init.sh

# Копируем Superset конфиг
COPY ./config/superset_config.py /app/superset_config.py
ENV SUPERSET_CONFIG_PATH=/app/superset_config.py

USER superset

ENTRYPOINT ["/app/superset_init.sh"]