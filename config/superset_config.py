import os
import pymysql

# Trick to make PyMySQL behave like MySQLdb
pymysql.install_as_MySQLdb()

FEATURE_FLAGS = {
    "ENABLE_TEMPLATE_PROCESSING": True,
}

PREVENT_UNSAFE_DB_CONNECTIONS = False
ENABLE_PROXY_FIX = True

SECRET_KEY = os.environ.get("SECRET_KEY")

# Твой MySQL URL
SQLALCHEMY_DATABASE_URI = os.environ.get("DATABASE_URL")