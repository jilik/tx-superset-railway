#!/bin/bash
set -e

echo "Starting Superset initialization..."

# Миграции и создание админа
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