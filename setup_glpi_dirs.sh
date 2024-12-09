#!/usr/bin/env bash
set -euo pipefail

GLPI_BASE_DIR="/home/glpi"
GLPI_HTTP_DIR="$GLPI_BASE_DIR/http"
GLPI_DB_DIR="$GLPI_BASE_DIR/db"
GLPI_USER="www-data"
GLPI_GROUP="www-data"
GLPI_PERMS="755"

# Função para checar se um path é um diretório
check_dir() {
    local dir_path="$1"
    if [ -e "$dir_path" ]; then
        if [ ! -d "$dir_path" ]; then
            echo "ERRO: '$dir_path' existe, mas não é um diretório."
            exit 1
        fi
    fi
}

# Função para criar diretório se não existir
create_dir_if_needed() {
    local dir_path="$1"
    if [ ! -d "$dir_path" ]; then
        echo "Criando diretório: $dir_path"
        mkdir -p "$dir_path"
    else
        echo "Diretório '$dir_path' já existe. Nenhuma ação necessária para criação."
    fi
}

# Função para ajustar permissões somente se necessário
adjust_permissions_if_needed() {
    local dir_path="$1"
    local desired_user="$2"
    local desired_group="$3"
    local desired_perms="$4"

    # Obtém o usuário e grupo atuais
    current_user=$(stat -c "%U" "$dir_path")
    current_group=$(stat -c "%G" "$dir_path")

    # Obtém permissões atuais (somente bits de permissão, ex: 755)
    current_perms=$(stat -c "%a" "$dir_path")

    # Verifica se precisa ajustar proprietário
    if [ "$current_user" != "$desired_user" ] || [ "$current_group" != "$desired_group" ]; then
        echo "Ajustando proprietário de '$dir_path' para $desired_user:$desired_group"
        chown -R "$desired_user":"$desired_group" "$dir_path"
    else
        echo "Proprietário de '$dir_path' já está conforme ($current_user:$current_group)."
    fi

    # Verifica se precisa ajustar permissões
    if [ "$current_perms" != "$desired_perms" ]; then
        echo "Ajustando permissões de '$dir_path' para $desired_perms"
        chmod -R "$desired_perms" "$dir_path"
    else
        echo "Permissões de '$dir_path' já estão conforme ($current_perms)."
    fi
}

echo "Iniciando configuração dos diretórios GLPI..."

# Verifica se o base dir existe ou é diretório
check_dir "$GLPI_BASE_DIR"

# Cria base dir se necessário
create_dir_if_needed "$GLPI_BASE_DIR"

# Cria subdiretórios se necessário
check_dir "$GLPI_HTTP_DIR"
create_dir_if_needed "$GLPI_HTTP_DIR"

check_dir "$GLPI_DB_DIR"
create_dir_if_needed "$GLPI_DB_DIR"

# Ajusta permissões se necessário
adjust_permissions_if_needed "$GLPI_BASE_DIR" "$GLPI_USER" "$GLPI_GROUP" "$GLPI_PERMS"

echo "Configuração dos diretórios GLPI concluída com sucesso!"
