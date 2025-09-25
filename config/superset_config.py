import os

FEATURE_FLAGS = {
    "ENABLE_TEMPLATE_PROCESSING": True,
}

PREVENT_UNSAFE_DB_CONNECTIONS = False
ENABLE_PROXY_FIX = True

SECRET_KEY = os.environ.get("SECRET_KEY")

# URL вашей базы данных PostgreSQL
# На Railway переменная DATABASE_URL создается автоматически
SQLALCHEMY_DATABASE_URI = os.environ.get(
    "DATABASE_URL",
    "postgresql+psycopg2://postgres:password@localhost:5432/superset"
)