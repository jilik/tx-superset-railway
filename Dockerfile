FROM apache/superset:latest

USER root

# Устанавливаем зависимости для PostgreSQL
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Ставим Python-библиотеки в виртуальное окружение Superset
RUN /app/.venv/bin/pip install --upgrade pip psycopg2-binary

# Копируем и настраиваем Superset
COPY config/superset_init.sh ./superset_init.sh
RUN chmod +x ./superset_init.sh

COPY config/superset_config.py /app/
ENV SUPERSET_CONFIG_PATH=/app/superset_config.py
ENV SECRET_KEY=$SECRET_KEY

# Переменные админа
ENV ADMIN_USERNAME=$ADMIN_USERNAME
ENV ADMIN_EMAIL=$ADMIN_EMAIL
ENV ADMIN_PASSWORD=$ADMIN_PASSWORD

USER superset

ENTRYPOINT ["./superset_init.sh"]