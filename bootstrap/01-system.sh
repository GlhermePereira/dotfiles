#!/usr/bin/env bash
# bootstrap/01-system.sh
# Atualiza o sistema e instala pacotes essenciais

set -e

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}ℹ${NC} $1"; }
log_ok() { echo -e "${GREEN}✓${NC} $1"; }
log_warn() { echo -e "${YELLOW}⚠${NC} $1"; }
log_err() { echo -e "${RED}✗${NC} $1"; }

DOTFILES_DIR="${DOTFILES_DIR:-.}"
PACKAGES_DIR="$DOTFILES_DIR/packages"

echo -e "${BLUE}=== Atualização do Sistema ===${NC}\n"

# Atualizar lista de pacotes
log_info "Atualizando lista de pacotes..."
sudo apt update

log_ok "Lista de pacotes atualizada"

# Upgrade
log_info "Instalando atualizações disponíveis..."
sudo apt upgrade -y

log_ok "Sistema atualizado"

# Instalar pacotes base
echo -e "\n${BLUE}=== Instalação de Pacotes Base ===${NC}\n"

if [ ! -f "$PACKAGES_DIR/base.txt" ]; then
    log_err "Arquivo de pacotes não encontrado: $PACKAGES_DIR/base.txt"
    exit 1
fi

log_info "Instalando pacotes base..."
# Remove comentários e linhas vazias
PACKAGES=$(grep -v '^#' "$PACKAGES_DIR/base.txt" | grep -v '^$' | tr '\n' ' ')

if [ -z "$PACKAGES" ]; then
    log_warn "Nenhum pacote para instalar"
else
    sudo apt install -y $PACKAGES
    log_ok "Pacotes base instalados"
fi

echo ""
echo -e "${GREEN}✓ Atualização do sistema concluída${NC}"
