#!/usr/bin/env bash
# install.sh - Script principal de instalação dos dotfiles
# Uso: ./install.sh [quick|interactive|custom]

set -e

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
NC='\033[0m'

log_info() { echo -e "${BLUE}ℹ${NC} $1"; }
log_ok() { echo -e "${GREEN}✓${NC} $1"; }
log_warn() { echo -e "${YELLOW}⚠${NC} $1"; }
log_err() { echo -e "${RED}✗${NC} $1"; }

# Obter diretório do script
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES_DIR

echo -e "${MAGENTA}"
cat << 'EOF'
╔═══════════════════════════════════════════════════════════════╗
║       Dotfiles Linux - Instalação Automatizada              ║
║       i3wm | zsh | neovim | alacritty | picom               ║
╚═══════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

# Verificar pré-requisitos
log_info "Executando verificações pré-instalação..."
if ! bash "$DOTFILES_DIR/bootstrap/00-check.sh"; then
    log_err "Falha nas verificações pré-instalação"
    exit 1
fi

# Modo de instalação
MODE="${1:-interactive}"

case "$MODE" in
    quick)
        log_info "Modo QUICK: instalação mínima"
        ;;
    interactive)
        log_info "Modo INTERACTIVE: você escolhe o que instalar"
        ;;
    custom)
        log_info "Modo CUSTOM: instalação personalizada"
        ;;
    *)
        log_warn "Modo desconhecido: $MODE"
        echo "Uso: $0 [quick|interactive|custom]"
        exit 1
        ;;
esac

echo ""

# Passo 1: Atualizar sistema
echo -e "${BLUE}[1/4]${NC} Atualização do sistema"
if bash "$DOTFILES_DIR/bootstrap/01-system.sh"; then
    log_ok "Sistema atualizado"
else
    log_warn "Erro na atualização do sistema"
fi

echo ""

# Passo 2: Instalar pacotes
echo -e "${BLUE}[2/4]${NC} Instalação de pacotes"
if [ "$MODE" = "quick" ]; then
    # Quick: apenas essenciais + terminal + desktop
    log_info "Instalando categorias: base, desktop, terminal"
    for cat in base desktop terminal; do
        PACKAGES=$(grep -v '^#' "$DOTFILES_DIR/packages/$cat.txt" | grep -v '^$' | tr '\n' ' ')
        if [ -n "$PACKAGES" ]; then
            sudo apt install -y $PACKAGES 2>/dev/null || true
        fi
    done
    log_ok "Pacotes rápidos instalados"
else
    # Interactive e custom: menu
    bash "$DOTFILES_DIR/bootstrap/02-packages.sh"
fi

echo ""

# Passo 3: Stow
echo -e "${BLUE}[3/4]${NC} Organização de dotfiles com stow"
bash "$DOTFILES_DIR/bootstrap/03-stow.sh"

echo ""

# Passo 4: Scripts pós-instalação (opcional)
echo -e "${BLUE}[4/4]${NC} Scripts pós-instalação (opcional)"
echo ""
echo "Scripts disponíveis:"
echo "  1) setup-shell.sh     - Oh My Zsh + plugins"
echo "  2) setup-fonts.sh     - Nerd Fonts"
echo "  3) setup-nvm.sh       - Node.js via nvm"
echo "  4) setup-pyenv.sh     - Python via pyenv"
echo "  5) Todos"
echo "  6) Nenhum (pular)"
echo ""

read -p "Escolha (1-6): " post_choice

case $post_choice in
    1)
        bash "$DOTFILES_DIR/scripts/setup-shell.sh"
        ;;
    2)
        bash "$DOTFILES_DIR/scripts/setup-fonts.sh"
        ;;
    3)
        bash "$DOTFILES_DIR/scripts/setup-nvm.sh"
        ;;
    4)
        bash "$DOTFILES_DIR/scripts/setup-pyenv.sh"
        ;;
    5)
        bash "$DOTFILES_DIR/scripts/setup-shell.sh"
        bash "$DOTFILES_DIR/scripts/setup-fonts.sh"
        bash "$DOTFILES_DIR/scripts/setup-nvm.sh"
        bash "$DOTFILES_DIR/scripts/setup-pyenv.sh"
        ;;
    6)
        log_warn "Scripts pós-instalação pulados"
        ;;
    *)
        log_warn "Opção inválida"
        ;;
esac

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║ ✓ Instalação concluída com sucesso!${NC}                  ${GREEN}║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════╝${NC}"

echo ""
echo "Próximos passos:"
echo "  1. Edite as configurações conforme necessário:"
echo "     ~/.config/i3/config          (window manager)"
echo "     ~/.config/alacritty/alacritty.toml (terminal)"
echo "     ~/.config/nvim/init.lua      (editor)"
echo ""
echo "  2. Inicie o X:"
echo "     startx"
echo ""
echo "  3. Documentação:"
echo "     - README.md"
echo "     - ARCHITECTURE.md"
echo "     - INSTALL.md"
echo ""
echo "  4. Dicas:"
echo "     - Atualize dotfiles: git -C $DOTFILES_DIR pull && stow -d $DOTFILES_DIR -t ~ -R *"
echo "     - Remova pacote: stow -d $DOTFILES_DIR -t ~ -D nvim"
echo ""
