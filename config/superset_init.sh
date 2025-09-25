#!/bin/bash
set -e

echo "Starting Superset initialization..."

# Обновляем мета-базу (PostgreSQL)
superset db upgrade

# Создаём администратора
export FLASK_APP=superset
superset fab create-admin \
    --username "$ADMIN_USERNAME" \
    --firstname "Superset" \
    --lastname "Admin" \
    --email "$ADMIN_EMAIL" \
    --password "$ADMIN_PASSWORD"

# Инициализация ролей и начальных данных
superset init

# Запуск Superset через стандартный run-server.sh
exec /bin/sh -c /usr/bin/run-server.sh