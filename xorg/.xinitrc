#!/bin/bash
# ~/.xinitrc - X11 initialization script
# Executed when starting X server

# Source user ~/.Xresources
[ -f "$HOME/.Xresources" ] && xrdb -merge "$HOME/.Xresources"

# Source user ~/.Xdefaults para compatibilidade
[ -f "$HOME/.Xdefaults" ] && xrdb -merge "$HOME/.Xdefaults"

# Definir teclado
setxkbmap -layout us -variant intl &

# Cursor invisível depois de X segundos
unclutter -idle 3 &

# Compositor
if command -v picom &>/dev/null; then
    picom -b
fi

# Monitor background
if command -v feh &>/dev/null; then
    [ -f "$HOME/.local/share/wallpapers/wallpaper.jpg" ] && \
        feh --bg-fill "$HOME/.local/share/wallpapers/wallpaper.jpg" &
fi

# Barra de status i3blocks (executado apenas para i3)
if command -v i3blocks &>/dev/null && [ -x "$HOME/.config/i3blocks/blocklets/apt" ]; then
    # i3blocks será iniciado por i3
    true
fi

# Iniciar window manager (i3 é o padrão)
exec i3
