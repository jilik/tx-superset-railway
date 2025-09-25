#!/bin/bash
set -e

# Создаём администратора
superset fab create-admin \
    --username "$ADMIN_USERNAME" \
    --firstname Superset \
    --lastname Admin \
    --email "$ADMIN_EMAIL" \
    --password "$ADMIN_PASSWORD"

# Обновляем базу данных Superset
superset db upgrade

# Инициализация ролей и прав
superset init

# Запуск сервера
exec superset run -p 8088 --with-threads --reload --debugger