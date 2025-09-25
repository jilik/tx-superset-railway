FROM apache/superset:latest

USER root

# Системные зависимости для PostgreSQL и MySQL драйверов
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    default-libmysqlclient-dev \
    && rm -rf /var/lib/apt/lists/*

# Установка Python-библиотек в виртуальное окружение Superset
RUN . /app/.venv/bin/activate && pip install --upgrade pip && pip install \
    psycopg2-binary \
    pymysql

# Переменные окружения для админа
ENV ADMIN_USERNAME=$ADMIN_USERNAME
ENV ADMIN_EMAIL=$ADMIN_EMAIL
ENV ADMIN_PASSWORD=$ADMIN_PASSWORD
ENV DATABASE_URL=$DATABASE_URL
ENV SECRET_KEY=$SECRET_KEY

# Копируем init скрипт и делаем его исполняемым
COPY ./config/superset_init.sh /app/superset_init.sh
RUN chmod +x /app/superset_init.sh

# Копируем Superset конфиг
COPY ./config/superset_config.py /app/superset_config.py
ENV SUPERSET_CONFIG_PATH=/app/superset_config.py

USER superset

ENTRYPOINT [ "/app/superset_init.sh" ]