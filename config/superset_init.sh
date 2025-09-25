#!/bin/bash

# Создание админа
superset fab create-admin \
    --username "$ADMIN_USERNAME" \
    --firstname Superset \
    --lastname Admin \
    --email "$ADMIN_EMAIL" \
    --password "$ADMIN_PASSWORD"

# Обновление базы данных Superset
superset db upgrade

# Настройка ролей и прав
superset init

# Запуск сервера
/bin/sh -c /usr/bin/run-server.sh