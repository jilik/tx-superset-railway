#!/bin/bash
set -e

echo "Starting Superset initialization on Railway..."

# Активируем виртуальное окружение
source /app/.venv/bin/activate

# Проверяем наличие psycopg2
python -c "import psycopg2; print('psycopg2 imported successfully')" || exit 1

# Ждем готовности базы данных (важно для Railway)
echo "Waiting for database to be ready..."
python -c "
import time
import os
from sqlalchemy import create_engine
from sqlalchemy.exc import OperationalError

db_url = os.environ.get('DATABASE_URL')
if not db_url:
    print('DATABASE_URL not set, using SQLite')
else:
    engine = create_engine(db_url)
    max_retries = 30
    for i in range(max_retries):
        try:
            conn = engine.connect()
            conn.close()
            print('Database connection successful')
            break
        except OperationalError as e:
            print(f'Database not ready, attempt {i+1}/{max_retries}')
            time.sleep(2)
    else:
        print('Failed to connect to database after all retries')
        exit(1)
"

# Выполняем миграции
echo "Running database migrations..."
superset db upgrade

# Создаем админа (только если не существует)
echo "Creating admin user..."
export FLASK_APP=superset
superset fab create-admin \
    --username "${ADMIN_USERNAME:-admin}" \
    --firstname "Superset" \
    --lastname "Admin" \
    --email "${ADMIN_EMAIL:-admin@superset.com}" \
    --password "${ADMIN_PASSWORD:-admin123}" 2>/dev/null || echo "Admin user already exists"

# Инициализируем Superset
echo "Initializing Superset..."
superset init

echo "Starting Superset server..."
# Запускаем сервер на порту, который Railway ожидает
exec superset run -p "${PORT:-8088}" --host "0.0.0.0"