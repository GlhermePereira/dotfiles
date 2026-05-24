#!/usr/bin/env bash
# bootstrap/00-check.sh
# Verifica pré-requisitos para instalação

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

ERRORS=0

echo -e "${BLUE}=== Verificando Pré-requisitos ===${NC}\n"

# Check OS
if ! grep -qi debian /etc/os-release 2>/dev/null && ! grep -qi ubuntu /etc/os-release 2>/dev/null; then
    log_err "Este script requer Debian ou Ubuntu"
    exit 1
fi
log_ok "Sistema Debian/Ubuntu detectado"

# Check apt
if ! command -v apt &>/dev/null; then
    log_err "apt não encontrado"
    exit 1
fi
log_ok "apt disponível"

# Check sudo
if ! sudo -n true 2>/dev/null; then
    log_warn "Você precisará inserir sua senha (teste de sudo)"
    if ! sudo -v; then
        log_err "Falha ao obter acesso sudo"
        exit 1
    fi
fi
log_ok "sudo configurado"

# Check git
if ! command -v git &>/dev/null; then
    log_warn "git não instalado, será instalado"
else
    log_ok "git disponível: $(git --version | cut -d' ' -f3)"
fi

# Check stow
if ! command -v stow &>/dev/null; then
    log_warn "stow não instalado, será instalado"
else
    log_ok "stow disponível: $(stow --version | head -1)"
fi

# Variáveis necessárias
if [ -z "$HOME" ]; then
    log_err "\$HOME não definido"
    exit 1
fi
log_ok "HOME=$HOME"

if [ ! -d "$HOME" ]; then
    log_err "HOME não é um diretório válido"
    exit 1
fi

# Espaço em disco
AVAILABLE=$(df "$HOME" | tail -1 | awk '{print $4}')
REQUIRED=500000  # 500MB
if [ "$AVAILABLE" -lt "$REQUIRED" ]; then
    log_err "Espaço em disco insuficiente (${AVAILABLE}K disponível, ${REQUIRED}K necessário)"
    exit 1
fi
log_ok "Espaço em disco: ${AVAILABLE}K disponível"

# Versão do Debian
DEBIAN_VERSION=$(cat /etc/debian_version 2>/dev/null || echo "unknown")
log_ok "Debian version: $DEBIAN_VERSION"

echo ""
if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}✓ Todos os pré-requisitos estão OK${NC}"
    echo ""
    exit 0
else
    echo -e "${RED}✗ $ERRORS erro(s) encontrado(s)${NC}"
    exit 1
fi
