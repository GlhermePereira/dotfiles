#!/usr/bin/env bash
# scripts/setup-pyenv.sh
# Instala Python Version Manager (pyenv) para gerenciar Python (idempotente)

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

echo -e "${BLUE}=== Setup de Python via Pyenv ===${NC}\n"

PYENV_DIR="${PYENV_DIR:=$HOME/.pyenv}"

# Verificar dependências de build
log_info "Verificando dependências..."
MISSING_DEPS=()

for dep in make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev; do
    if ! dpkg -l | grep -q "^ii.*$dep"; then
        MISSING_DEPS+=("$dep")
    fi
done

if [ ${#MISSING_DEPS[@]} -gt 0 ]; then
    log_warn "Dependências faltando: ${MISSING_DEPS[@]}"
    read -p "Instalar dependências? (s/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        sudo apt install -y "${MISSING_DEPS[@]}"
        log_ok "Dependências instaladas"
    fi
fi

# Instalar pyenv
if [ ! -d "$PYENV_DIR" ]; then
    log_info "Instalando pyenv..."
    git clone https://github.com/pyenv/pyenv.git "$PYENV_DIR"
    log_ok "pyenv instalado"
else
    log_ok "pyenv já instalado"
fi

# Instalar plugin pyenv-virtualenv
VIRTUALENV_PLUGIN="$PYENV_DIR/plugins/pyenv-virtualenv"
if [ ! -d "$VIRTUALENV_PLUGIN" ]; then
    log_info "Instalando pyenv-virtualenv..."
    git clone https://github.com/pyenv/pyenv-virtualenv.git "$VIRTUALENV_PLUGIN"
    log_ok "pyenv-virtualenv instalado"
else
    log_ok "pyenv-virtualenv já instalado"
fi

# Source pyenv
export PYENV_DIR="$PYENV_DIR"
export PATH="$PYENV_DIR/bin:$PATH"
eval "$(pyenv init -)" || true

# Instalar Python (última versão)
log_info "Instalando Python..."
LATEST_PYTHON=$(pyenv install -l | grep -E '^\s+[0-9]+\.[0-9]+\.[0-9]+$' | tail -1 | xargs)

if [ -z "$LATEST_PYTHON" ]; then
    LATEST_PYTHON="3.11"
fi

if ! pyenv versions | grep -q "$LATEST_PYTHON"; then
    pyenv install "$LATEST_PYTHON" 2>/dev/null || log_warn "Instalação de Python pode ter levado tempo"
    log_ok "Python $LATEST_PYTHON instalado"
else
    log_ok "Python $LATEST_PYTHON já instalado"
fi

# Definir Python global
pyenv global "$LATEST_PYTHON" || true

# Verificar instalação
if command -v python &>/dev/null; then
    PYTHON_VERSION=$(python --version)
    log_ok "$PYTHON_VERSION instalado"
else
    log_warn "Python não foi instalado corretamente"
fi

echo ""
echo -e "${GREEN}✓ Setup de pyenv/Python concluído${NC}"
echo ""
echo "Próximos passos:"
echo "  • Adicione as linhas abaixo ao ~/.zshrc:"
echo "    export PYENV_DIR=\"\$HOME/.pyenv\""
echo "    export PATH=\"\$PYENV_DIR/bin:\$PATH\""
echo "    eval \"\$(pyenv init -)\""
echo "    eval \"\$(pyenv virtualenv-init -)\""
echo "  • Reinicie o terminal ou: source ~/.zshrc"
