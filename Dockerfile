# Базовый образ Superset
FROM apache/superset:latest

# Работаем от root, чтобы ставить зависимости
USER root

# Установка системных пакетов для сборки mysqlclient и ODBC
RUN apt-get update && apt-get install -y \
    pkg-config \
    libmariadb-dev \
    unixodbc \
    unixodbc-dev \
    gcc \
    g++ \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Установка Python-зависимостей
RUN pip install --upgrade pip && pip install \
    mysqlclient \
    pymongo \
    pymssql \
    pyodbc

# Переменные окружения для администратора Superset
ENV ADMIN_USERNAME=$ADMIN_USERNAME
ENV ADMIN_EMAIL=$ADMIN_EMAIL
ENV ADMIN_PASSWORD=$ADMIN_PASSWORD
ENV SECRET_KEY=$SECRET_KEY
ENV SUPERSET_CONFIG_PATH=/app/superset_config.py

# Копируем скрипт и делаем его исполняемым
COPY /config/superset_init.sh ./superset_init.sh
RUN chmod +x ./superset_init.sh

# Копируем конфиг Superset
COPY /config/superset_config.py /app/

# Возвращаемся к пользователю superset
USER superset

# Точка входа
ENTRYPOINT ["./superset_init.sh"]