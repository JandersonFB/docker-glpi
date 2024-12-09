#!/usr/bin/env bash

# Definir variáveis de diretórios
GLPI_BASE_DIR="/home/glpi"
GLPI_HTTP_DIR="$GLPI_BASE_DIR/http"
GLPI_DB_DIR="$GLPI_BASE_DIR/db"
GLPI_USER="www-data"
GLPI_GROUP="www-data"

# Cria os diretórios caso não existam
mkdir -p "$GLPI_HTTP_DIR" "$GLPI_DB_DIR"

# Ajusta o proprietário e grupo
chown -R "$GLPI_USER":"$GLPI_GROUP" "$GLPI_BASE_DIR"

# Ajusta as permissões
# 755 para leitura e execução por todos, escrita apenas para o proprietário
chmod -R 755 "$GLPI_BASE_DIR"

echo "Diretórios do GLPI criados e permissões ajustadas."
