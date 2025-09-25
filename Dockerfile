FROM apache/superset:latest

USER root

# Устанавливаем зависимости для MySQL и других драйверов
RUN apt-get update && apt-get install -y \
    build-essential \
    default-libmysqlclient-dev \
    libssl-dev \
    unixodbc-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Обновляем pip и ставим Python-библиотеки в виртуальное окружение Superset
RUN . /app/.venv/bin/activate && pip install --upgrade pip && pip install \
    pymysql \
    pymongo \
    pymssql \
    pyodbc

# Копируем и настраиваем Superset
COPY /config/superset_init.sh ./superset_init.sh
RUN chmod +x ./superset_init.sh

COPY /config/superset_config.py /app/
ENV SUPERSET_CONFIG_PATH /app/superset_config.py

# Переменные админа
ENV ADMIN_USERNAME=$ADMIN_USERNAME
ENV ADMIN_EMAIL=$ADMIN_EMAIL
ENV ADMIN_PASSWORD=$ADMIN_PASSWORD
ENV SECRET_KEY=$SECRET_KEY

USER superset

ENTRYPOINT [ "./superset_init.sh" ]