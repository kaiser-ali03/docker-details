#!/bin/sh

echo "Waiting for PostgreSQL..."

while ! nc -z db 5432; do
  sleep 2
done

echo "Database ready."

python manage.py migrate

python manage.py collectstatic --noinput

exec gunicorn config.wsgi:application \
      --bind 0.0.0.0:8000 \
      --workers=4 \
      --threads=2 \
      --timeout=120 \
      --access-logfile - \
      --error-logfile -
