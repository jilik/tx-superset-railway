import os

FEATURE_FLAGS = {
    "ENABLE_TEMPLATE_PROCESSING": True,
}

PREVENT_UNSAFE_DB_CONNECTIONS = False
ENABLE_PROXY_FIX = True
SECRET_KEY = os.environ.get("SECRET_KEY")

# MySQL connection
SQLALCHEMY_DATABASE_URI = os.environ.get(
    "DATABASE_URL",
    "mysql://superset:superset_password@mysql_host:3306/superset_db"
)