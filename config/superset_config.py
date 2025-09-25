import os

FEATURE_FLAGS = {
    "ENABLE_TEMPLATE_PROCESSING": True,
}

PREVENT_UNSAFE_DB_CONNECTIONS = False
ENABLE_PROXY_FIX = True

# Секретный ключ
SECRET_KEY = os.environ.get("SECRET_KEY", "fallback_secret")

# Подключение к мета-базе PostgreSQL
SQLALCHEMY_DATABASE_URI = os.environ.get(
    "DATABASE_URL",
    "sqlite:////app/superset.db"  # fallback для локальной разработки
)