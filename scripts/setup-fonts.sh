#!/usr/bin/env bash
# scripts/setup-fonts.sh
# Instala Nerd Fonts para terminal e editor (idempotente)

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

echo -e "${BLUE}=== Setup de Fontes ===${NC}\n"

FONTS_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONTS_DIR"

# Nerd Fonts recomendadas
declare -A FONTS=(
    ["FiraCode"]="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.0/FiraCode.zip"
    ["JetBrainsMono"]="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.0/JetBrainsMono.zip"
)

cd "$FONTS_DIR"

for font_name in "${!FONTS[@]}"; do
    font_dir="$FONTS_DIR/$font_name"
    
    if [ -d "$font_dir" ]; then
        log_ok "$font_name já instalada"
        continue
    fi
    
    log_info "Instalando $font_name..."
    mkdir -p "$font_dir"
    
    # Download e instala
    temp_file=$(mktemp)
    if curl -fsSL "${FONTS[$font_name]}" -o "$temp_file"; then
        unzip -q "$temp_file" -d "$font_dir"
        rm "$temp_file"
        log_ok "$font_name instalada"
    else
        log_warn "Falha ao baixar $font_name"
        rm -rf "$font_dir"
    fi
done

# Rebuild fontconfig cache
log_info "Atualizando cache de fontes..."
fc-cache -fv "$FONTS_DIR" >/dev/null 2>&1 || true

log_ok "Rebuild completado"

echo ""
echo -e "${GREEN}✓ Setup de fontes concluído${NC}"
echo ""
echo "Próximos passos:"
echo "  • Reinicie o terminal"
echo "  • Configure a fonte em ~/.config/alacritty/alacritty.toml"
