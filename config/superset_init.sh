#!/bin/bash

# Создаём админа
superset fab create-admin \
  --username "$ADMIN_USERNAME" \
  --firstname Superset \
  --lastname Admin \
  --email "$ADMIN_EMAIL" \
  --password "$ADMIN_PASSWORD"

# Миграции
superset db upgrade

# Инициализация ролей и пермишнов
superset init

# Запуск сервера
/bin/sh -c /usr/bin/run-server.sh