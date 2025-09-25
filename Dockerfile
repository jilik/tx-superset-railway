FROM apache/superset:latest

USER root

# Системные зависимости для PostgreSQL
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Переменные окружения для админа и секретов
ENV ADMIN_USERNAME=${ADMIN_USERNAME}
ENV ADMIN_EMAIL=${ADMIN_EMAIL}
ENV ADMIN_PASSWORD=${ADMIN_PASSWORD}
ENV SECRET_KEY=${SECRET_KEY}
ENV SUPERSET_CONFIG_PATH=/app/superset_config.py

# Копируем init скрипт и делаем его исполняемым
COPY ./config/superset_init.sh /app/superset_init.sh
RUN chmod +x /app/superset_init.sh

# Копируем конфиг Superset
COPY ./config/superset_config.py /app/superset_config.py

# Возвращаемся к пользователю Superset
USER superset

# Запуск init скрипта
ENTRYPOINT ["/app/superset_init.sh"]