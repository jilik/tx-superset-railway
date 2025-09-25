#!/bin/bash
set -e

# Если venv ещё не создан, Superset создаст его
# Устанавливаем psycopg2 в виртуальное окружение
/app/.venv/bin/pip install --upgrade pip psycopg2-binary

# Миграции и инициализация
superset db upgrade
superset init

# Создаём админа
superset fab create-admin \
  --username "$ADMIN_USERNAME" \
  --firstname Superset \
  --lastname Admin \
  --email "$ADMIN_EMAIL" \
  --password "$ADMIN_PASSWORD"

exec /usr/bin/run-server.sh