#!/bin/bash
set -e

echo "Starting Superset initialization..."

# Устанавливаем драйверы прямо в venv Superset
/app/.venv/bin/pip install --no-cache-dir \
    psycopg2-binary \
    pymongo \
    pymssql \
    pyodbc \
    mysqlclient

# Инициализируем базу данных
superset db upgrade

# Создаём админа, если его ещё нет
export FLASK_APP=superset
superset fab create-admin \
    --username "$ADMIN_USERNAME" \
    --firstname "Superset" \
    --lastname "Admin" \
    --email "$ADMIN_EMAIL" \
    --password "$ADMIN_PASSWORD" || true

# Инициализируем роли и начальные данные
superset init

# Запуск Superset
exec /usr/bin/run-server.sh