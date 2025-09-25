# Берем dev образ, в котором уже есть psycopg2 и все зависимости
FROM apache/superset:latest-dev

USER root

# Копируем твой конфиг Superset
COPY ./config/superset_config.py /app/superset_config.py
ENV SUPERSET_CONFIG_PATH=/app/superset_config.py

# Копируем init скрипт
COPY ./config/superset_init.sh /app/superset_init.sh
RUN chmod +x /app/superset_init.sh

# Устанавливаем переменные окружения для админа
ENV ADMIN_USERNAME=admin
ENV ADMIN_EMAIL=admin@example.com
ENV ADMIN_PASSWORD=admin
ENV SECRET_KEY=mysecretkey

USER superset

# Твой init скрипт будет запускаться при старте
ENTRYPOINT [ "/app/superset_init.sh" ]