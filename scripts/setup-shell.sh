#!/usr/bin/env bash
# scripts/setup-shell.sh
# Configura zsh com Oh My Zsh e plugins (idempotente)

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

echo -e "${BLUE}=== Setup do Shell (Zsh + Oh My Zsh) ===${NC}\n"

# Verificar zsh
if ! command -v zsh &>/dev/null; then
    log_warn "zsh não instalado, pule este script ou instale zsh primeiro"
    exit 1
fi

# Instalar Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    log_info "Instalando Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    log_ok "Oh My Zsh instalado"
else
    log_ok "Oh My Zsh já instalado"
fi

# Instalar plugins
PLUGINS_DIR="$HOME/.oh-my-zsh/custom/plugins"
mkdir -p "$PLUGINS_DIR"

# zsh-autosuggestions
if [ ! -d "$PLUGINS_DIR/zsh-autosuggestions" ]; then
    log_info "Instalando zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$PLUGINS_DIR/zsh-autosuggestions"
    log_ok "zsh-autosuggestions instalado"
else
    log_ok "zsh-autosuggestions já instalado"
fi

# zsh-completions
if [ ! -d "$PLUGINS_DIR/zsh-completions" ]; then
    log_info "Instalando zsh-completions..."
    git clone https://github.com/zsh-users/zsh-completions "$PLUGINS_DIR/zsh-completions"
    log_ok "zsh-completions instalado"
else
    log_ok "zsh-completions já instalado"
fi

# fast-syntax-highlighting
if [ ! -d "$PLUGINS_DIR/fast-syntax-highlighting" ]; then
    log_info "Instalando fast-syntax-highlighting..."
    git clone https://github.com/zdharma-continuum/fast-syntax-highlighting "$PLUGINS_DIR/fast-syntax-highlighting"
    log_ok "fast-syntax-highlighting instalado"
else
    log_ok "fast-syntax-highlighting já instalado"
fi

# Definir zsh como shell padrão
if [ "$SHELL" != "$(which zsh)" ]; then
    log_info "Definindo zsh como shell padrão..."
    chsh -s "$(which zsh)"
    log_ok "zsh definido como shell padrão"
else
    log_ok "zsh já é o shell padrão"
fi

echo ""
echo -e "${GREEN}✓ Setup do shell concluído${NC}"
echo ""
echo "Próximos passos:"
echo "  • Reinicie o terminal ou execute: exec zsh"
echo "  • Edite ~/.zshrc se necessário"
