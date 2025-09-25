#!/bin/bash
set -e

# Создание админа, если переменные заданы
if [ -n "$ADMIN_USERNAME" ] && [ -n "$ADMIN_PASSWORD" ] && [ -n "$ADMIN_EMAIL" ]; then
    superset fab create-admin \
        --username "$ADMIN_USERNAME" \
        --firstname Superset \
        --lastname Admin \
        --email "$ADMIN_EMAIL" \
        --password "$ADMIN_PASSWORD"
fi

# Обновление базы данных Superset
superset db upgrade

# Настройка ролей и прав
superset init

# Запуск сервера
exec superset run -p 8088 --with-threads --reload --debugger