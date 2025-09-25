#!/bin/bash
set -e

# Виртуальное окружение уже используется Superset, psycopg2-binary установлен
superset db upgrade
superset init

# Создаем админа
superset fab create-admin \
    --username "$ADMIN_USERNAME" \
    --firstname Superset \
    --lastname Admin \
    --email "$ADMIN_EMAIL" \
    --password "$ADMIN_PASSWORD"

# Запуск Superset
exec /usr/bin/run-server.sh