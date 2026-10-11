#!/usr/bin/env bash

choice=$(
    printf '  Desligar\n󰍃  Terminar sessão\n󰜉  Reiniciar\n' |
        wofi --dmenu \
             --prompt "Energia" \
             --width 340 \
             --height 240 \
             --cache-file /dev/null
)

case "$choice" in
    *Desligar)
        confirm=$(printf 'Cancelar\nDesligar agora' |
            wofi --dmenu --prompt "Confirmar desligar" --width 340 --height 140 --cache-file /dev/null)
        [[ "$confirm" == "Desligar agora" ]] && systemctl poweroff
        ;;
    *"Terminar sessão")
        confirm=$(printf 'Cancelar\nTerminar sessão agora' |
            wofi --dmenu --prompt "Confirmar saída" --width 340 --height 140 --cache-file /dev/null)
	[[ "$confirm" == "Terminar sessão agora" ]] && hyprctl dispatch 'hl.dsp.exit()'
        ;;
    *Reiniciar)
        confirm=$(printf 'Cancelar\nReiniciar agora' |
            wofi --dmenu --prompt "Confirmar reinício" --width 340 --height 140 --cache-file /dev/null)
        [[ "$confirm" == "Reiniciar agora" ]] && systemctl reboot
        ;;
esac
