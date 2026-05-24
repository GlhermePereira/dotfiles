#!/usr/bin/env bash
# bootstrap/02-packages.sh
# Instala pacotes por categoria (interativo)

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

DOTFILES_DIR="${DOTFILES_DIR:-.}"
PACKAGES_DIR="$DOTFILES_DIR/packages"

echo -e "${BLUE}=== Instalação de Pacotes por Categoria ===${NC}\n"

# Função para instalar pacotes de um arquivo
install_category() {
    local category=$1
    local file="$PACKAGES_DIR/$category.txt"
    
    if [ ! -f "$file" ]; then
        log_warn "Arquivo não encontrado: $file"
        return
    fi
    
    # Remove comentários e linhas vazias
    PACKAGES=$(grep -v '^#' "$file" | grep -v '^$' | tr '\n' ' ')
    
    if [ -z "$PACKAGES" ]; then
        log_warn "Nenhum pacote em $category"
        return
    fi
    
    log_info "Instalando $category..."
    sudo apt install -y $PACKAGES
    log_ok "$category instalado"
}

# Menu interativo
show_menu() {
    echo -e "\n${BLUE}Selecione as categorias para instalar:${NC}\n"
    echo "1) desktop    - Window manager, composição, X11"
    echo "2) terminal   - Terminal, shell, ferramentas CLI"
    echo "3) dev        - Desenvolvimento (nvim, gcc, python)"
    echo "4) optional   - Nice-to-have (rofi, flameshot)"
    echo "5) Tudo"
    echo "6) Nada (pular)"
    echo ""
}

# Ler seleção
read -p "Escolha (1-6): " choice

case $choice in
    1)
        install_category "desktop"
        ;;
    2)
        install_category "terminal"
        ;;
    3)
        install_category "dev"
        ;;
    4)
        install_category "optional"
        ;;
    5)
        log_info "Instalando todas as categorias..."
        for cat in desktop terminal dev optional; do
            install_category "$cat"
        done
        ;;
    6)
        log_warn "Instalação de pacotes pulada"
        ;;
    *)
        log_warn "Opção inválida, pulando"
        ;;
esac

echo ""
echo -e "${GREEN}✓ Instalação de pacotes concluída${NC}"
