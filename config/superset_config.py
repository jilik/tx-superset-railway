import os

SQLALCHEMY_DATABASE_URI = os.getenv(
    "DATABASE_URL", "postgresql://superset:superset@db:5432/superset"
)
SECRET_KEY = os.getenv("SECRET_KEY", "mysecretkey")