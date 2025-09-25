import os
from urllib.parse import quote_plus

# Основные настройки
SECRET_KEY = os.environ.get("SECRET_KEY", "your-secret-key-here")

# Настройки базы данных
DATABASE_URL = os.environ.get("DATABASE_URL")
if DATABASE_URL:
    # Railway иногда предоставляет URL с postgres://, но SQLAlchemy требует postgresql://
    if DATABASE_URL.startswith("postgres://"):
        DATABASE_URL = DATABASE_URL.replace("postgres://", "postgresql://", 1)
    
    SQLALCHEMY_DATABASE_URI = DATABASE_URL
else:
    # Fallback на SQLite для локальной разработки
    SQLALCHEMY_DATABASE_URI = "sqlite:////app/superset.db"

# Настройки безопасности
PREVENT_UNSAFE_DB_CONNECTIONS = False
ENABLE_PROXY_FIX = True

# Настройки для Railway (обрабатываем прокси)
WTF_CSRF_ENABLED = True
WTF_CSRF_TIME_LIMIT = None

# Разрешаем загрузку CSV файлов
FEATURE_FLAGS = {
    "ENABLE_TEMPLATE_PROCESSING": True,
    "ALLOW_ADHOC_SUBQUERY": True,
}

# Настройки веб-сервера
WEBDRIVER_BASEURL = os.environ.get("RAILWAY_STATIC_URL", "http://localhost:8088/")

# Кэш настройки для лучшей производительности
CACHE_CONFIG = {
    'CACHE_TYPE': 'SimpleCache',
    'CACHE_DEFAULT_TIMEOUT': 300
}

# Логирование
ENABLE_TIME_ROTATE = True

# Настройки CORS для Railway
CORS_OPTIONS = {
    'supports_credentials': True,
    'origins': ['*'],
}

# Тайм-ауты для Railway
SQLALCHEMY_ENGINE_OPTIONS = {
    'pool_pre_ping': True,
    'pool_recycle': 300,
    'connect_args': {
        'connect_timeout': 10,
    } if 'postgresql' in SQLALCHEMY_DATABASE_URI else {}
}