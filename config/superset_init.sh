#!/bin/bash
set -e

# --- Создаём psycopg2 в виртуальном окружении Superset ---
if [ -f "/app/.venv/bin/pip" ]; then
    echo "Installing psycopg2-binary in Superset venv..."
    /app/.venv/bin/pip install --upgrade pip psycopg2-binary
else
    echo "Virtualenv not found! Exiting..."
    exit 1
fi

# --- Миграции базы и инициализация ---
superset db upgrade
superset init

# --- Создание админа ---
superset fab create-admin \
    --username "$ADMIN_USERNAME" \
    --firstname Superset \
    --lastname Admin \
    --email "$ADMIN_EMAIL" \
    --password "$ADMIN_PASSWORD"

# --- Запуск сервера ---
exec /usr/bin/run-server.sh