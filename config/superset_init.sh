#!/bin/bash
set -e

echo "Starting Superset initialization..."

# Если venv ещё нет — создаём его
if [ ! -d "/app/.venv" ]; then
    python3 -m venv /app/.venv
fi

# Устанавливаем зависимости внутри venv
/app/.venv/bin/pip install --upgrade pip
/app/.venv/bin/pip install psycopg2-binary pymongo pymssql pyodbc mysqlclient

# Инициализация базы и создание админа
superset db upgrade
export FLASK_APP=superset
superset fab create-admin \
    --username "$ADMIN_USERNAME" \
    --firstname "Superset" \
    --lastname "Admin" \
    --email "$ADMIN_EMAIL" \
    --password "$ADMIN_PASSWORD" || true

superset init

# Запуск сервера
exec superset run -p 8088 --host 0.0.0.0