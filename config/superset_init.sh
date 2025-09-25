#!/bin/bash
set -e

echo "Starting Superset initialization..."

# Проверяем, где находится venv
if [ -d "/app/.venv" ]; then
    PIP="/app/.venv/bin/pip"
elif [ -d "/app/venv" ]; then
    PIP="/app/venv/bin/pip"
else
    echo "Virtual environment not found, exiting"
    exit 1
fi

echo "Using pip at $PIP"

# Устанавливаем драйверы прямо в venv
$PIP install --no-cache-dir \
    psycopg2-binary \
    pymongo \
    pymssql \
    pyodbc \
    mysqlclient

# Инициализация базы данных
superset db upgrade

# Создание админа
export FLASK_APP=superset
superset fab create-admin \
    --username "$ADMIN_USERNAME" \
    --firstname "Superset" \
    --lastname "Admin" \
    --email "$ADMIN_EMAIL" \
    --password "$ADMIN_PASSWORD" || true

# Инициализация ролей и старт
superset init

# Запуск сервера
exec /usr/bin/run-server.sh