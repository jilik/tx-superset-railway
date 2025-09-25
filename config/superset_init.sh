#!/bin/bash

# Создаем админа
superset fab create-admin \
    --username "$ADMIN_USERNAME" \
    --firstname Superset \
    --lastname Admin \
    --email "$ADMIN_EMAIL" \
    --password "$ADMIN_PASSWORD"

# Обновляем базу
superset db upgrade

# Инициализация ролей и прав
superset init

# Запуск Superset
/bin/sh -c /usr/bin/run-server.sh