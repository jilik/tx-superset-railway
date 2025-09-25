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

# Определяем порт, который задаёт Railway (по умолчанию 8088)
PORT="${PORT:-8088}"

# Запуск Superset на 0.0.0.0 для доступности извне
exec superset run -h 0.0.0.0 -p "$PORT" --with-threads --reload --debugger