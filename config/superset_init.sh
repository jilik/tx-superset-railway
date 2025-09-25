#!/bin/bash
set -e

# Обновляем pip и ставим psycopg2 (ещё раз, на всякий)
pip install --upgrade pip psycopg2-binary

# Применяем миграции и инициализацию
superset db upgrade
superset init

# Создаем админа, если нужно
superset fab create-admin \
    --username "$ADMIN_USERNAME" \
    --firstname Superset \
    --lastname Admin \
    --email "$ADMIN_EMAIL" \
    --password "$ADMIN_PASSWORD"

# Запускаем стандартный сервер Superset
exec /usr/bin/run-server.sh