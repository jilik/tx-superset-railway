#!/bin/bash
set -e

echo "Starting Superset initialization..."

export FLASK_APP=superset

# Обновляем мета-базу (PostgreSQL)
superset db upgrade

# Создаём администратора
superset fab create-admin \
    --username "$ADMIN_USERNAME" \
    --firstname "Superset" \
    --lastname "Admin" \
    --email "$ADMIN_EMAIL" \
    --password "$ADMIN_PASSWORD"

# Инициализация ролей и данных
superset init

# Запуск Superset
exec /bin/sh -c /usr/bin/run-server.sh
