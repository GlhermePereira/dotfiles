#!/usr/bin/env bash
# scripts/setup-nvm.sh
# Instala Node Version Manager (nvm) para gerenciar Node.js (idempotente)

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

echo -e "${BLUE}=== Setup de Node.js via NVM ===${NC}\n"

NVM_DIR="${NVM_DIR:=$HOME/.nvm}"

# Instalar nvm
if [ ! -d "$NVM_DIR" ]; then
    log_info "Instalando nvm..."
    mkdir -p "$NVM_DIR"
    
    # Clone nvm
    git clone --depth 1 https://github.com/nvm-sh/nvm.git "$NVM_DIR" || true
    
    # Source nvm
    export NVM_DIR="$NVM_DIR"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    
    log_ok "nvm instalado"
else
    log_ok "nvm já instalado"
    export NVM_DIR="$NVM_DIR"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi

# Instalar Node.js (LTS)
log_info "Instalando Node.js LTS..."
nvm install node --lts 2>/dev/null || log_warn "Node.js instalação pode ter falhado"

# Node padrão
nvm use node || true

# Verificar instalação
if command -v node &>/dev/null; then
    NODE_VERSION=$(node --version)
    log_ok "Node.js instalado: $NODE_VERSION"
    log_ok "npm: $(npm --version)"
else
    log_warn "Node.js não foi instalado corretamente"
fi

echo ""
echo -e "${GREEN}✓ Setup de nvm/Node.js concluído${NC}"
echo ""
echo "Próximos passos:"
echo "  • Adicione a linha abaixo ao ~/.zshrc:"
echo "    export NVM_DIR=\"\$HOME/.nvm\""
echo "    [ -s \"\$NVM_DIR/nvm.sh\" ] && \\. \"\$NVM_DIR/nvm.sh\""
echo "  • Reinicie o terminal ou: source ~/.zshrc"
