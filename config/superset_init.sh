#!/bin/bash
set -e

# Инициализация базы данных
superset db upgrade

# Создание администратора, если его нет
if ! superset fab list-users | grep -q "$ADMIN_USERNAME"; then
  superset fab create-admin \
    --username "$ADMIN_USERNAME" \
    --firstname Superset \
    --lastname Admin \
    --email "$ADMIN_EMAIL" \
    --password "$ADMIN_PASSWORD"
fi

# Настройка ролей и прав
superset init

# Запуск Superset
exec superset run -p 8088 --with-threads --reload --debugger