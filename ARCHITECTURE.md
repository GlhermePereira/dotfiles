# Análise Arquitetônica - Dotfiles Linux Moderno

## Estado Atual

```
dotfiles/
├── alacritty/          (56 MB - contém tema git completo)
├── i3/                 (20 KB - essencial)
├── i3blocks/           (16 KB - essencial)
├── nvim/               (16 KB - essencial)
├── picom/              (16 KB - essencial)
├── zsh/                (12 KB - essencial)
├── wallpapers/         (5.3 MB - assets)
├── install/
│   └── debian.sh       (básico)
└── packages/
    └── debian.txt      (monolítico)
```

## Problemas Identificados

### 🚨 Críticos (Remover)
1. **alacritty/themes/.git** - Repositório git desnecessário (56MB)
   - Solução: Manter apenas o alacritty.toml
2. **wallpapers/** - Assets devem ficar separados
   - Solução: Mover para assets/ ou documentar link externo
3. **packages/debian.txt** - Monolítico, impossível filtrar
   - Problemas:
     - network-manager-gnome (GUI pesada, desnecessária)
     - thunar (FILE MANAGER GUI)
     - pavucontrol (GUI pesada)
     - tmux (redundante com zsh moderno)

### ⚠️ Problemas de Organização
4. **Falta separação de camadas**
   - Sem scripts de bootstrap
   - Sem hook pós-instalação
   - Sem detecção de dependências

5. **Faltam configurações prioritárias**
   - rofi (launcher moderno)
   - Xresources (tema de cores terminal)
   - systemd (oneshots, timers)

## Estrutura Desejada

```
dotfiles/
├── .github/
│   ├── workflows/      (CI/CD)
│   └── ISSUE_TEMPLATE/
├── bootstrap/          (Instalação do zero)
│   ├── 00-check.sh     (Validações)
│   ├── 01-system.sh    (Atualizações)
│   ├── 02-packages.sh  (Pacotes)
│   └── 03-stow.sh      (Symlinks)
├── scripts/            (Utilidades pós-instalação)
│   ├── setup-shell.sh  (Oh My Zsh, plugins)
│   ├── setup-fonts.sh  (Nerd fonts)
│   ├── setup-nvm.sh    (Node)
│   └── setup-pyenv.sh  (Python)
├── packages/           (Modular, categorizado)
│   ├── base.txt        (essentials: git, curl, build-essential)
│   ├── desktop.txt     (i3, xorg, picom, feh)
│   ├── terminal.txt    (alacritty, zsh, fzf, ripgrep)
│   ├── dev.txt         (nvim, nodejs, python, docker)
│   └── optional.txt    (rofi, flameshot, pavucontrol)
├── alacritty/          (Sem .git, sem themes pesados)
│   └── .config/alacritty/
├── i3/
│   └── .config/i3/
├── i3blocks/
│   ├── .config/i3blocks/
│   └── .local/share/i3blocks/  (scripts)
├── nvim/
│   └── .config/nvim/
├── picom/
│   └── .config/picom/
├── rofi/               (NOVO)
│   └── .config/rofi/
├── xresources/         (NOVO)
│   └── .Xresources
├── zsh/
│   └── .zshrc
├── xorg/               (NOVO)
│   └── .xinitrc
├── README.md
├── INSTALL.md
└── install.sh          (Entry point único)
```

## Decisões Arquiteturais

### 1. **Sem vendor/submodules de temas**
- Temas vêm de sources online ou via setup scripts
- Reduz bloat e merge conflicts
- Alacritty carrega tema via `include`

### 2. **Pacotes separados por categoria**
- Permite instalação incremental
- Fácil customizar em diferentes máquinas
- Clara separação de responsabilidades

### 3. **Bootstrap separado de dotfiles**
- `install.sh` → Dispatcher
- `bootstrap/` → Scripts POSIX simples
- Permite testar em containers

### 4. **Scripts pós-instalação isolados**
- Não dependem de stow
- Idempotentes (rodar múltiplas vezes = safe)
- Apenas configuração de aplicação

### 5. **Nenhum hardcoding de paths**
- Usa `$HOME`, `$XDG_CONFIG_HOME`
- Portável entre usuários
- Compatível com diferentes Linux

## Pacotes a Remover

```
❌ network-manager-gnome  → Use nmcli (terminal)
❌ thunar                 → Não essencial (GUI)
❌ pavucontrol            → Use pactl/amixer (terminal)
❌ tmux                   → Desnecessário (zsh moderno)
❌ playerctl             → Pouco usado
❌ brightnessctl         → Sys-specific
```

## Pacotes a Adicionar

```
✅ rofi                   → Launcher moderno
✅ xsel/xclip            → Clipboard manager
✅ exa                   → ls moderno (opcional)
✅ jq                    → JSON query
✅ imagemagick           → Imagem processing
✅ ffmpeg                → Mídia
```

## Workflow Final

```bash
# 1. Clone
git clone https://github.com/seu-user/dotfiles.git ~/dotfiles

# 2. Bootstrap automático
cd ~/dotfiles && ./install.sh

# 3. Responde questões (minimalista/full)

# 4. Sai com sistema 100% pronto
```

## Benefícios

✅ Modular - Pega só o que quer
✅ Reproduzível - Mesma saída toda vez
✅ Sem bloat - Alacritty -56MB
✅ Profissional - Estrutura Clara
✅ Portável - Roda em qualquer Debian
✅ Idempotente - Safe rodar múltiplas vezes
✅ Testável - Scripts isolados
✅ Documentado - INSTALL.md completo
