# Dotfiles Linux Moderno - i3wm Edition

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Debian](https://img.shields.io/badge/OS-Debian-A81D33?logo=debian)](https://www.debian.org/)
[![Shell](https://img.shields.io/badge/Shell-Bash-4EAA25?logo=bash)](https://www.gnu.org/software/bash/)

Dotfiles minimalistas, modulares, reproduzíveis e fáceis de manter para desenvolvimento moderno em Linux com i3wm.

## ⚡ Início Rápido

```bash
# Clone
git clone https://github.com/seu-usuario/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Instale
./install.sh

# Reinicie X
startx
```

**Tempo estimado**: 5-10 minutos (depende da conexão)

## 📋 O que inclui

### Window Manager & Compositor
- **i3** - Tiling window manager leve
- **i3blocks** - Status bar dinâmica
- **picom** - Compositor X11 (shadows, transparência)

### Terminal & Shell
- **alacritty** - Terminal GPU-acelerado
- **zsh** - Shell com oh-my-zsh
- **fzf** - Busca interativa
- **ripgrep** - grep moderno

### Editor & Dev
- **neovim** - Editor modal moderno
- **python3** - Scripting
- **gcc/g++** - Compiladores
- **git** - Versionamento

### Utilitários
- **rofi** - Application launcher
- **feh** - Wallpaper manager
- **xclip** - Clipboard
- **bat** - cat moderno

## 🎯 Características

✅ **Modular** - Instale apenas o que precisa
✅ **Reproduzível** - Mesmo setup em qualquer máquina
✅ **Sem bloat** - ~50KB de configuração
✅ **Profissional** - Estrutura clara e bem documentada
✅ **Idempotente** - Seguro rodar múltiplas vezes
✅ **Testado** - Scripts com tratamento de erros
✅ **Portável** - Debian/Ubuntu 20.04+

## 📁 Estrutura

```
dotfiles/
├── bootstrap/              # Scripts de instalação
│   ├── 00-check.sh        # Verificações pré-requisitos
│   ├── 01-system.sh       # Atualização sistema
│   ├── 02-packages.sh     # Instalação categorizada
│   └── 03-stow.sh         # Symlinks com stow
├── scripts/               # Pós-instalação (opcional)
│   ├── setup-shell.sh     # Oh My Zsh
│   ├── setup-fonts.sh     # Nerd Fonts
│   ├── setup-nvm.sh       # Node.js
│   └── setup-pyenv.sh     # Python
├── packages/              # Listas de pacotes
│   ├── base.txt           # Essenciais
│   ├── desktop.txt        # i3, composição
│   ├── terminal.txt       # Alacritty, zsh
│   ├── dev.txt            # Desenvolvimento
│   └── optional.txt       # Nice-to-have
├── alacritty/             # Configuração terminal
├── i3/                    # Configuração window manager
├── i3blocks/              # Status bar
├── nvim/                  # Editor
├── picom/                 # Compositor
├── rofi/                  # Launcher
├── xorg/                  # X11 resources
├── zsh/                   # Shell
├── install.sh             # Entry point
└── README.md              # Este arquivo
```

## 🚀 Instalação Completa

### 1. Verificar Pré-requisitos
```bash
bash bootstrap/00-check.sh
```

### 2. Atualizar Sistema
```bash
bash bootstrap/01-system.sh
```

### 3. Instalar Pacotes (Escolher Categorias)
```bash
bash bootstrap/02-packages.sh
```

### 4. Aplicar Dotfiles
```bash
bash bootstrap/03-stow.sh
```

### 5. Scripts Pós-Instalação (Opcional)
```bash
# Shell moderno
bash scripts/setup-shell.sh

# Fontes
bash scripts/setup-fonts.sh

# Node.js via nvm
bash scripts/setup-nvm.sh

# Python via pyenv
bash scripts/setup-pyenv.sh
```

## 📚 Documentação

- **[INSTALL.md](./INSTALL.md)** - Guia detalhado de instalação
- **[ARCHITECTURE.md](./ARCHITECTURE.md)** - Decisões arquitetônicas

## 🔧 Customização

### Editar Configurações Após Instalação

```bash
# Window manager
$EDITOR ~/.config/i3/config

# Terminal
$EDITOR ~/.config/alacritty/alacritty.toml

# Editor
$EDITOR ~/.config/nvim/init.lua

# Shell
$EDITOR ~/.zshrc
```

### Adicionar Novo Pacote

```bash
# Criar estrutura
mkdir -p ~/dotfiles/novo-app/.config/novo-app

# Copiar config
cp ~/.config/novo-app/config ~/dotfiles/novo-app/.config/novo-app/

# Instalar
stow -d ~/dotfiles -t ~ novo-app
```

## 🎨 Temas & Cores

- **Terminal**: Nord theme
- **Compositor**: Picom com shadows e blur
- **Fontes**: JetBrainsMono Nerd Font
- **Cursor**: Adwaita (X11)

Customize em:
- `alacritty/.config/alacritty/alacritty.toml`
- `xorg/.Xresources`

## 🐛 Troubleshooting

### X não inicia
```bash
startx -- -nolisten tcp
# Ver logs: ~/.local/share/xorg/Xvfb.log
```

### Stow falha com conflitos
```bash
# Backup
mv ~/.config/i3 ~/.config/i3.bak

# Retry
stow -d ~/dotfiles -t ~ i3
```

### Shell continua em bash
```bash
chsh -s $(which zsh)
# Logout/login para aplicar
```

Mais em [INSTALL.md#troubleshooting](./INSTALL.md#troubleshooting)

## 🔄 Manutenção

### Atualizar Dotfiles
```bash
cd ~/dotfiles && git pull && stow -d . -t ~ -R *
```

### Desinstalar Pacote
```bash
stow -d ~/dotfiles -t ~ -D i3
```

### Limpar Sistema
```bash
sudo apt autoremove && sudo apt autoclean
```

## 📊 Tamanho

- **Dotfiles**: ~50KB
- **Pacotes base**: ~500MB
- **Com dev tools**: ~2GB

## 🎓 Recursos

- [GNU Stow Docs](https://www.gnu.org/software/stow/manual/)
- [i3wm Docs](https://i3wm.org/docs/)
- [Alacritty Docs](https://github.com/alacritty/alacritty)
- [Neovim Docs](https://neovim.io/doc/)

## 📝 Licença

MIT License

## 🤝 Contribuições

1. Fork o projeto
2. Crie uma branch feature
3. Commit suas mudanças
4. Push para a branch
5. Abra um Pull Request

---

**Criado**: 2024
**Testado em**: Debian 12, Ubuntu 22.04+

Se achou útil, considere dar uma ⭐!
