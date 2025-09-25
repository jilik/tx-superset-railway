import os
import pymysql
pymysql.install_as_MySQLdb()  # Для MySQL через pymysql, если нужен MySQL

FEATURE_FLAGS = {
    "ENABLE_TEMPLATE_PROCESSING": True,
}

PREVENT_UNSAFE_DB_CONNECTIONS = False
ENABLE_PROXY_FIX = True

SECRET_KEY = os.environ.get("SECRET_KEY")

# URL вашей базы данных
# Для PostgreSQL в Railway: DATABASE_URL будет автоматически задан
SQLALCHEMY_DATABASE_URI = os.environ.get(
    "DATABASE_URL",
    "postgresql+psycopg2://postgres:password@localhost:5432/superset"
)