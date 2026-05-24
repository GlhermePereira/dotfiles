#!/usr/bin/env bash
# bootstrap/03-stow.sh
# Usa GNU stow para criar symlinks dos dotfiles

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

echo -e "${BLUE}=== Organizando Dotfiles com GNU Stow ===${NC}\n"

# Verificar stow
if ! command -v stow &>/dev/null; then
    log_err "stow não está instalado"
    log_info "Execute o bootstrap 01 ou: sudo apt install stow"
    exit 1
fi

# Listar pacotes disponíveis
PACKAGES=()
for dir in "$DOTFILES_DIR"/{alacritty,i3,i3blocks,nvim,picom,rofi,xorg,zsh}; do
    if [ -d "$dir" ]; then
        PACKAGES+=($(basename "$dir"))
    fi
done

if [ ${#PACKAGES[@]} -eq 0 ]; then
    log_err "Nenhum pacote de dotfiles encontrado"
    exit 1
fi

log_info "Pacotes disponíveis: ${PACKAGES[@]}"

# Menu
echo -e "\n${BLUE}Selecione os pacotes para instalar:${NC}\n"
echo "1) Minimalista (i3, zsh, nvim, alacritty, picom)"
echo "2) Padrão (minimalista + rofi, xorg)"
echo "3) Todos os pacotes"
echo "4) Personalizado"
echo "5) Pular stow (instalar depois)"
echo ""
read -p "Escolha (1-5): " choice

STOW_PACKAGES=()

case $choice in
    1)
        STOW_PACKAGES=(i3 zsh nvim alacritty picom)
        ;;
    2)
        STOW_PACKAGES=(i3 zsh nvim alacritty picom rofi xorg)
        ;;
    3)
        STOW_PACKAGES=("${PACKAGES[@]}")
        ;;
    4)
        echo -e "\n${BLUE}Escolha os pacotes (separados por espaço):${NC}"
        echo "Disponíveis: ${PACKAGES[@]}"
        read -p "Pacotes: " -a STOW_PACKAGES
        ;;
    5)
        log_warn "stow pulado. Execute depois: stow -d $DOTFILES_DIR -t ~ i3 zsh nvim"
        exit 0
        ;;
    *)
        log_warn "Opção inválida, pulando stow"
        exit 0
        ;;
esac

# Backup de conflitos
echo -e "\n${YELLOW}⚠ Verificando conflitos com configurações existentes...${NC}"

CONFLICTS=0
for pkg in "${STOW_PACKAGES[@]}"; do
    if [ ! -d "$DOTFILES_DIR/$pkg" ]; then
        log_warn "Pacote não encontrado: $pkg"
        continue
    fi
    
    # Procura por arquivos que já existem no home
    if [ -d "$DOTFILES_DIR/$pkg/.config" ]; then
        for config_dir in "$DOTFILES_DIR/$pkg/.config"/*; do
            config_name=$(basename "$config_dir")
            home_config="$HOME/.config/$config_name"
            if [ -e "$home_config" ] && [ ! -L "$home_config" ]; then
                log_warn "Arquivo existente: $home_config"
                CONFLICTS=$((CONFLICTS + 1))
            fi
        done
    fi
done

if [ $CONFLICTS -gt 0 ]; then
    echo -e "\n${YELLOW}⚠ $CONFLICTS arquivo(s) em conflito encontrado(s)${NC}"
    read -p "Deseja fazer backup dos arquivos existentes? (s/n): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        BACKUP_DIR="$HOME/.config.backup.$(date +%Y%m%d_%H%M%S)"
        mkdir -p "$BACKUP_DIR"
        log_info "Criando backup em $BACKUP_DIR"
        
        for pkg in "${STOW_PACKAGES[@]}"; do
            if [ -d "$DOTFILES_DIR/$pkg/.config" ]; then
                for config_dir in "$DOTFILES_DIR/$pkg/.config"/*; do
                    config_name=$(basename "$config_dir")
                    home_config="$HOME/.config/$config_name"
                    if [ -e "$home_config" ] && [ ! -L "$home_config" ]; then
                        cp -r "$home_config" "$BACKUP_DIR/" || true
                        rm -rf "$home_config"
                    fi
                done
            fi
        done
        
        log_ok "Backup criado: $BACKUP_DIR"
    fi
fi

# Instalar com stow
echo -e "\n${BLUE}Instalando dotfiles com stow...${NC}\n"

cd "$HOME"
for pkg in "${STOW_PACKAGES[@]}"; do
    if [ -d "$DOTFILES_DIR/$pkg" ]; then
        log_info "Instalando $pkg..."
        if stow -d "$DOTFILES_DIR" -t "$HOME" "$pkg"; then
            log_ok "$pkg instalado"
        else
            log_err "Erro ao instalar $pkg (veja acima)"
        fi
    fi
done

echo ""
echo -e "${GREEN}✓ Stow concluído${NC}"
echo ""
echo "Próximos passos:"
echo "  • Executar scripts pós-instalação: bash $DOTFILES_DIR/scripts/setup-shell.sh"
echo "  • Verificar ~/.xinitrc ou ~/.bashrc"
echo "  • Reiniciar o X: \`startx\` ou fazer logout"
