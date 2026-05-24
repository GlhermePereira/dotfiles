# Quick Reference - Dotfiles Linux Moderno

## 🚀 Instalação Express (copie e cole)

```bash
git clone https://github.com/seu-usuario/dotfiles.git ~/dotfiles
cd ~/dotfiles && ./install.sh quick
```

## 📋 Tabela de Decisão

| Situação | Comando |
|----------|---------|
| **Novo sistema** | `./install.sh` (interactive) |
| **Mínimo viável** | `./install.sh quick` |
| **Atualizar existente** | `git pull && stow -d . -t ~ -R *` |
| **Apenas shell** | `bash bootstrap/01-system.sh` |
| **Apenas desktop** | `bash bootstrap/02-packages.sh` (escolha 1) |
| **Oh My Zsh** | `bash scripts/setup-shell.sh` |
| **Node.js** | `bash scripts/setup-nvm.sh` |
| **Python** | `bash scripts/setup-pyenv.sh` |

## 📦 Pacotes por Categoria

```bash
# Ver pacotes base
cat packages/base.txt

# Ver todos
cat packages/{base,desktop,terminal,dev,optional}.txt

# Instalar categoria manualmente
sudo apt install $(grep -v '^#' packages/terminal.txt | tr '\n' ' ')
```

## 🔧 Editar Configurações

| App | Arquivo | Atalho |
|-----|---------|--------|
| i3 | `~/.config/i3/config` | Win+Shift+C |
| Alacritty | `~/.config/alacritty/alacritty.toml` | - |
| Neovim | `~/.config/nvim/init.lua` | `:edit $MYVIMRC` |
| Zsh | `~/.zshrc` | - |
| Rofi | `~/.config/rofi/config.rasi` | - |
| X11 | `~/.Xresources` | `xrdb -merge ~/.Xresources` |

## 🎮 Atalhos i3 Úteis

```
Win+Return       - Novo terminal
Win+D            - Rofi (launcher)
Win+Shift+C      - Reload config
Win+Shift+R      - Restart i3
Win+Shift+E      - Logout
Win+1..9         - Workspace 1-9
Win+Shift+1..9   - Mover para workspace
Win+H/V          - Split horizontal/vertical
Win+Enter        - Fullscreen
Win+[/]          - Resize
```

## 🐛 Diagnóstico Rápido

```bash
# Verificar stow
ls -la ~/.config/i3 2>/dev/null && echo "✓ Stow OK" || echo "✗ Stow falhou"

# Verificar pacotes
dpkg -l | grep -E 'i3|alacritty|neovim' | wc -l

# Verificar shell
echo $SHELL

# Verificar X
echo $DISPLAY

# Verificar fonts
fc-list | grep -i jetbrains
```

## 📁 Estrutura Completa

```
dotfiles/
├── bootstrap/
│   ├── 00-check.sh           (800B)
│   ├── 01-system.sh          (1.2K)
│   ├── 02-packages.sh        (1.8K)
│   └── 03-stow.sh            (3.5K)
├── scripts/
│   ├── setup-shell.sh        (1.5K)
│   ├── setup-fonts.sh        (1.2K)
│   ├── setup-nvm.sh          (1.8K)
│   └── setup-pyenv.sh        (2.1K)
├── packages/
│   ├── base.txt              (300B)
│   ├── desktop.txt           (400B)
│   ├── terminal.txt          (500B)
│   ├── dev.txt               (400B)
│   └── optional.txt          (500B)
├── alacritty/
│   └── .config/alacritty/
│       └── alacritty.toml    (600B)
├── i3/
│   └── .config/i3/
│       └── config            (7K)
├── nvim/
│   └── .config/nvim/
│       └── init.lua          (700B)
├── zsh/
│   └── .zshrc                (5K)
├── rofi/
│   └── .config/rofi/
│       └── config.rasi       (3K)
├── xorg/
│   ├── .xinitrc              (800B)
│   └── .Xresources           (1.2K)
└── docs/
    ├── README.md             (5K)
    ├── INSTALL.md            (8K)
    └── ARCHITECTURE.md       (5K)

Total: ~50KB de config
```

## 🔄 Fluxo de Trabalho Diário

```bash
# Editar config
nvim ~/.config/i3/config

# Recarregar i3
Win+Shift+C (ou) i3-msg reload

# Commit mudanças
cd ~/dotfiles
git add -A
git commit -m "Update i3 config"
git push

# Sincronizar em outra máquina
cd ~/dotfiles && git pull
stow -d . -t ~ -R i3
```

## ⚠️ Armadilhas Comuns

| Problema | Causa | Solução |
|----------|-------|---------|
| "command not found: stow" | stow não instalado | `sudo apt install stow` |
| Conflito de arquivos | Config existente | `mv ~/.config/i3 ~/.config/i3.bak` |
| X não inicia | xinitrc quebrado | `cat ~/.xinitrc` |
| Zsh não é default | Shell não trocado | `chsh -s $(which zsh)` |
| Fontes não aparecem | Cache sujo | `fc-cache -fv ~/.local/share/fonts` |

## 🎯 Checklist Pós-Instalação

- [ ] `./install.sh` completou sem erros
- [ ] `ls ~/.config/i3` mostra symlink para dotfiles
- [ ] `startx` inicia i3 sem erros
- [ ] Testar atalhos i3 (Win+D, Win+Return)
- [ ] Shell padrão é zsh: `echo $SHELL`
- [ ] Node.js instalado (opcional): `node --version`
- [ ] Python instalado: `python3 --version`
- [ ] Git configurado: `git config --global user.name`
- [ ] Customizar configs conforme necessário
- [ ] Fazer commit inicial: `git add . && git commit -m "Initial setup"`

## 🔗 Links Úteis

- [i3wm Docs](https://i3wm.org/docs/) - Manual oficial i3
- [Alacritty Config](https://raw.githubusercontent.com/alacritty/alacritty/master/alacritty.toml) - Exemplo config
- [Neovim Init.lua](https://neovim.io/doc/user/lua.html) - Lua guide
- [Oh My Zsh Plugins](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins) - Lista de plugins
- [GNU Stow Manual](https://www.gnu.org/software/stow/manual/) - Documentação stow

## 🆘 Suporte Rápido

```bash
# Log de instalação
bash bootstrap/*.sh 2>&1 | tee install.log

# Verificar erros
grep -i error install.log

# Stow dry-run (sem fazer nada)
stow -d ~/dotfiles -t ~ --no i3

# Ver o que foi instalado
stow -d ~/dotfiles -t ~ -R --verbose i3 2>&1 | head -20
```

---

**Última atualização**: 2024
**Versão**: 1.0.0
