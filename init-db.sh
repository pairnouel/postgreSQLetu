#!/bin/bash
set -e

# Afficher le contenu du répertoire avant toute opération
echo "Contenu avant :"
ls -l /docker-entrypoint-initdb.d/

# Attendre que le serveur PostgreSQL soit prêt
until pg_isready -h postgres -p 5432 -U "$POSTGRES_USER"; do
  echo "Waiting for PostgreSQL..."
  sleep 2
done

# Installer unzip, décompresser l'archive et restaurer la base de données
apt-get update && apt-get install -y unzip
unzip /docker-entrypoint-initdb.d/dump/dvdrental.zip -d /docker-entrypoint-initdb.d/dump
pg_restore -U "$POSTGRES_USER" -d "$POSTGRES_DB" /docker-entrypoint-initdb.d/dump/dvdrental.tar

# Créer la base de données pgwatch2
psql -U "$POSTGRES_USER" -c "CREATE DATABASE pgwatch2;"

# Afficher le contenu du répertoire après toute opération
echo "Contenu après :"
ls -l /docker-entrypoint-initdb.d/