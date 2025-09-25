FROM apache/superset:latest

USER root

# Устанавливаем зависимости для сборки драйверов баз данных
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

# Копируем скрипты и конфиг
COPY config/superset_init.sh /superset_init.sh
COPY config/superset_config.py /app/superset_config.py
RUN chmod +x /superset_init.sh

# Передаём переменные окружения
ENV SUPERSET_CONFIG_PATH=/app/superset_config.py
ENV ADMIN_USERNAME=${ADMIN_USERNAME}
ENV ADMIN_EMAIL=${ADMIN_EMAIL}
ENV ADMIN_PASSWORD=${ADMIN_PASSWORD}
ENV SECRET_KEY=${SECRET_KEY}
ENV DATABASE_URL=${DATABASE_URL}

USER superset

# ENTRYPOINT запускаем через наш скрипт
ENTRYPOINT ["/superset_init.sh"]