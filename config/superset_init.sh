#!/bin/bash
set -e

echo "Starting Superset initialization..."

# Устанавливаем драйверы Python
pip install --no-cache-dir \
    psycopg2-binary \
    pymongo \
    pymssql \
    pyodbc \
    mysqlclient

# Обновляем мета-базу (PostgreSQL)
superset db upgrade

# Создаем администратора
superset fab create-admin \
    --username "$ADMIN_USERNAME" \
    --firstname "Superset" \
    --lastname "Admin" \
    --email "$ADMIN_EMAIL" \
    --password "$ADMIN_PASSWORD"

# Инициализация ролей и начальных данных
superset init

# Запуск Superset
exec /bin/sh -c /usr/bin/run-server.sh