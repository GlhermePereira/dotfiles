# Guia de Instalação - Dotfiles Linux Moderno

## Visão Geral

Este guia cobre a instalação de um novo sistema Debian/Ubuntu com todos os dotfiles pré-configurados para desenvolvimento em i3wm.

## Pré-requisitos

- **Sistema**: Debian 12+ ou Ubuntu 22.04+
- **Conexão**: Internet funcionando
- **Privilégios**: Acesso sudo
- **Espaço**: 2GB livres no disco
- **Shell**: bash ou zsh

## Instalação Rápida (5 minutos)

```bash
# 1. Clonar repositório
git clone https://github.com/seu-usuario/dotfiles.git ~/dotfiles
cd ~/dotfiles

# 2. Executar instalação
./install.sh quick

# 3. Reiniciar X ou logout/login
startx
```

## Instalação Detalhada

### 1. Clone do Repositório

```bash
git clone https://github.com/seu-usuario/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 2. Verificação de Pré-requisitos

```bash
bash bootstrap/00-check.sh
```

Este script verifica:
- Debian/Ubuntu detectado
- apt disponível
- sudo funcionando
- Espaço em disco suficiente
- Versão do Debian

### 3. Atualização do Sistema

```bash
bash bootstrap/01-system.sh
```

Faz:
- `apt update`
- `apt upgrade`
- Instala pacotes base essenciais

### 4. Instalação de Pacotes (Categorizado)

```bash
bash bootstrap/02-packages.sh
```

Escolha uma opção:

```
1) desktop    - i3, picom, xorg (window manager)
2) terminal   - alacritty, zsh, fzf, ripgrep
3) dev        - neovim, gcc, python3, git
4) optional   - rofi, flameshot, fonts
5) Tudo       - todas as categorias
6) Nada       - pular
```

**Recomendado**: Escolha "5" para instalação completa.

### 5. Aplicar Dotfiles com Stow

```bash
bash bootstrap/03-stow.sh
```

Escolha uma opção:

```
1) Minimalista  - i3, zsh, nvim, alacritty, picom
2) Padrão       - minimalista + rofi, xorg
3) Todos        - todos os pacotes
4) Personalizado- você escolhe
5) Pular        - instalar depois
```

**Recomendado**: Escolha "2" para padrão.

Este passo cria symlinks do `~/dotfiles` para `~/.config/`, `~/`, etc.

### 6. Scripts Pós-Instalação (Opcional)

```bash
bash scripts/setup-shell.sh      # Oh My Zsh + plugins
bash scripts/setup-fonts.sh      # Nerd Fonts
bash scripts/setup-nvm.sh        # Node.js via nvm
bash scripts/setup-pyenv.sh      # Python via pyenv
```

## Modo Automatizado (Tudo em Um Comando)

```bash
cd ~/dotfiles && ./install.sh quick
```

Opciones disponíveis:
- `./install.sh quick` - Instalação rápida (base + desktop + terminal)
- `./install.sh interactive` - Menu interativo (padrão)
- `./install.sh custom` - Personalização completa

## Configurações Pós-Instalação

### 1. Editar Configurações

Após a instalação, ajuste conforme necessário:

**Window Manager (i3):**
```bash
$EDITOR ~/.config/i3/config
```

**Terminal (Alacritty):**
```bash
$EDITOR ~/.config/alacritty/alacritty.toml
```

**Editor (Neovim):**
```bash
$EDITOR ~/.config/nvim/init.lua
```

**Shell (Zsh):**
```bash
$EDITOR ~/.zshrc
```

### 2. Iniciando o X11

#### Opção A: startx
```bash
startx
```

#### Opção B: Display Manager
Se estiver usando um DM (lightdm, sddm):
```bash
sudo systemctl start display-manager
```

#### Opção C: Automático no Login
Adicione ao fim de `~/.profile`:
```bash
if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ]; then
    startx
fi
```

### 3. Verificar Instalação

```bash
# Verificar symlinks criados
ls -la ~/.config/i3
ls -la ~/.config/alacritty
ls -la ~/.config/nvim

# Verificar pacotes instalados
dpkg -l | grep -E 'i3|alacritty|neovim'

# Testar stow
stow -d ~/dotfiles -t ~ --noop i3  # noop = dry-run
```

## Estrutura de Pacotes

### Base (`packages/base.txt`)
- git, curl, wget
- build-essential
- Essenciais para qualquer sistema

### Desktop (`packages/desktop.txt`)
- i3, i3blocks
- picom (compositor)
- xorg, xclip, xsel
- feh (wallpaper)

### Terminal (`packages/terminal.txt`)
- alacritty
- zsh, fzf, ripgrep, fd
- bat, jq
- htop, btop

### Dev (`packages/dev.txt`)
- neovim
- python3, gcc, gdb
- git-flow

### Optional (`packages/optional.txt`)
- rofi (launcher)
- flameshot (screenshots)
- Fonts (Noto, FiraCode)

## Troubleshooting

### ❌ "stow not found"
```bash
sudo apt install stow
```

### ❌ "Permission denied" em bootstrap
```bash
chmod +x ~/dotfiles/bootstrap/*.sh
chmod +x ~/dotfiles/scripts/*.sh
chmod +x ~/dotfiles/install.sh
```

### ❌ Conflito de arquivos existentes
```bash
# Backup manual
mv ~/.config/i3 ~/.config/i3.bak

# Então rodar bootstrap/03-stow.sh novamente
```

### ❌ X não inicia
```bash
# Verificar ~/.xinitrc
cat ~/.xinitrc

# Testar X
startx -- -nolisten tcp

# Ver logs
cat ~/.local/share/xorg/Xvfb.log
```

### ❌ Zsh não é shell padrão
```bash
# Definir manualmente
chsh -s $(which zsh)

# Verificar
echo $SHELL
```

### ❌ Fontes não aparecem em alacritty
```bash
# Rebuild fontconfig
fc-cache -fv ~/.local/share/fonts

# Verificar fonte
fc-list | grep JetBrains

# Em alacritty.toml, especifique:
# family = "JetBrainsMono Nerd Font Mono"
```

## Atualizações Futuras

### Sincronizar com Repositório
```bash
cd ~/dotfiles
git pull
```

### Reinstalar Dotfiles Após Atualização
```bash
stow -d ~/dotfiles -t ~ -R alacritty i3 nvim picom zsh rofi xorg
```

### Adicionar Novo Pacote ao Stow
1. Crie a pasta: `mkdir -p ~/dotfiles/meu-app/.config/meu-app`
2. Copie o config: `cp ~/.config/meu-app/config ~/dotfiles/meu-app/.config/meu-app/`
3. Instale: `stow -d ~/dotfiles -t ~ meu-app`

## Desinstalação

### Remover Dotfiles Específicos
```bash
stow -d ~/dotfiles -t ~ -D i3
```

### Remover Tudo
```bash
cd ~/dotfiles && for pkg in */; do
    stow -d ~/dotfiles -t ~ -D "$(basename $pkg)"
done
```

### Remover Pacotes do Sistema
```bash
# Remover todos
sudo apt autoremove -y

# Remover categoria
sudo apt remove -y $(grep -v '^#' packages/optional.txt | grep -v '^$')
```

## Recursos Adicionais

- [GNU Stow Manual](https://www.gnu.org/software/stow/manual/)
- [i3 Documentation](https://i3wm.org/docs/)
- [Neovim Docs](https://neovim.io/doc/)
- [Alacritty Configuration](https://github.com/alacritty/alacritty/blob/master/alacritty.toml)

## Suporte

Para problemas:

1. Verifique a saída do script: `bash bootstrap/*.sh 2>&1 | tee install.log`
2. Consulte `ARCHITECTURE.md` para entender a estrutura
3. Abra uma issue no repositório

## Próximas Passos

Após instalação bem-sucedida:

1. ✅ Customize seu i3 config
2. ✅ Configure seu terminal (fontes, cores)
3. ✅ Edite seu nvim config (plugins, etc)
4. ✅ Instale ferramentas opcionais (nvm, pyenv)
5. ✅ Faça commit das suas mudanças

```bash
cd ~/dotfiles
git add .
git commit -m "Personalizadas minhas configurações"
git push
```

---

**Versão**: 1.0.0  
**Data**: 2024  
**Mantido por**: Você!
