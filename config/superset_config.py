import os
import pymysql
pymysql.install_as_MySQLdb()  # Чтобы SQLAlchemy понял MySQL через pymysql

FEATURE_FLAGS = {
    "ENABLE_TEMPLATE_PROCESSING": True,
}

PREVENT_UNSAFE_DB_CONNECTIONS = False
ENABLE_PROXY_FIX = True

SECRET_KEY = os.environ.get("SECRET_KEY")

# URL вашей базы данных MySQL
SQLALCHEMY_DATABASE_URI = os.environ.get(
    "DATABASE_URL",
    "mysql+pymysql://root:password@localhost:3306/superset"
)