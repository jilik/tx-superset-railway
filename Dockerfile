FROM apache/superset:latest

USER root

# Устанавливаем системные зависимости
RUN apt-get update && apt-get install -y \
    pkg-config libmariadb-dev unixodbc unixodbc-dev libpq-dev gcc g++ \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Находим правильный путь к pip в контейнере Superset
RUN which pip || echo "Global pip not found"
RUN find /app -name "pip*" 2>/dev/null || echo "No pip found in /app"
RUN ls -la /app/ || echo "/app directory not found"

# Устанавливаем зависимости глобально (так как venv не найден)
RUN pip install --no-cache-dir \
    psycopg2-binary==2.9.9 \
    pymongo \
    pymssql \
    pyodbc \
    mysqlclient

# Создаем скрипт инициализации прямо в Dockerfile
RUN cat > /superset_init.sh << 'EOF'
#!/bin/bash
set -e

echo "Starting Superset initialization on Railway..."

# Проверяем наличие psycopg2
python -c "import psycopg2; print('psycopg2 imported successfully')" || exit 1

# Ждем готовности базы данных
echo "Waiting for database to be ready..."
python -c "
import time
import os
from sqlalchemy import create_engine
from sqlalchemy.exc import OperationalError

db_url = os.environ.get('DATABASE_URL')
if db_url:
    if db_url.startswith('postgres://'):
        db_url = db_url.replace('postgres://', 'postgresql://', 1)
    
    engine = create_engine(db_url)
    max_retries = 30
    for i in range(max_retries):
        try:
            conn = engine.connect()
            conn.close()
            print('Database connection successful')
            break
        except Exception as e:
            print(f'Database not ready, attempt {i+1}/{max_retries}: {e}')
            time.sleep(2)
    else:
        print('Failed to connect to database after all retries')
        exit(1)
else:
    print('No DATABASE_URL provided, using SQLite')
"

# Выполняем миграции
echo "Running database migrations..."
superset db upgrade

# Создаем админа
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
exec superset run -p "${PORT:-8088}" --host "0.0.0.0"
EOF

# Создаем конфигурационный файл прямо в Dockerfile
RUN cat > /app/superset_config.py << 'EOF'
import os

# Основные настройки
SECRET_KEY = os.environ.get("SECRET_KEY", "your-secret-key-change-this")

# Настройки базы данных
DATABASE_URL = os.environ.get("DATABASE_URL")
if DATABASE_URL:
    if DATABASE_URL.startswith("postgres://"):
        DATABASE_URL = DATABASE_URL.replace("postgres://", "postgresql://", 1)
    SQLALCHEMY_DATABASE_URI = DATABASE_URL
else:
    SQLALCHEMY_DATABASE_URI = "sqlite:////app/superset.db"

# Настройки безопасности
PREVENT_UNSAFE_DB_CONNECTIONS = False
ENABLE_PROXY_FIX = True
WTF_CSRF_ENABLED = True
WTF_CSRF_TIME_LIMIT = None

# Функции
FEATURE_FLAGS = {
    "ENABLE_TEMPLATE_PROCESSING": True,
    "ALLOW_ADHOC_SUBQUERY": True,
}

# Кэш
CACHE_CONFIG = {
    'CACHE_TYPE': 'SimpleCache',
    'CACHE_DEFAULT_TIMEOUT': 300
}

# Настройки движка БД
SQLALCHEMY_ENGINE_OPTIONS = {
    'pool_pre_ping': True,
    'pool_recycle': 300,
}
EOF

RUN chmod +x /superset_init.sh

# Настройки окружения
ENV SUPERSET_CONFIG_PATH=/app/superset_config.py
ENV PYTHONPATH=/app

USER superset

# Экспозим порт
EXPOSE 8088

ENTRYPOINT ["/superset_init.sh"]