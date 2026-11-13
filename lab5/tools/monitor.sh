#!/usr/bin/env bash
set -euo pipefail
source "$(dirname -- "${BASH_SOURCE[0]}")/common.sh"
[[ $# -eq 2 ]] || fail "Uso: monitor.sh S|C|BR PUERTO"
case "$1" in S|C|BR) ;; RCP) fail "El RCP no tiene shell. Verifícalo desde BR con ot rcp version." ;; *) fail "Etiqueta inválida." ;; esac
check_port "$2"
printf 'Monitor %s en %s a 115200 baudios. Salir Ctrl+]. No guardes credenciales ni datasets.\n' "$1" "$PORT"
# Serial monitoring needs pyserial, not west or a Zephyr workspace. Prefer the
# host-tools venv (also usable on a PC without Zephyr), then the active Python.
if [[ -x "$LAB5_DIR/.venv/bin/python" ]]; then
    PYTHON="$LAB5_DIR/.venv/bin/python"
elif command -v python >/dev/null 2>&1; then
    PYTHON="$(command -v python)"
else
    PYTHON="$(command -v python3 || true)"
fi
[[ -n "$PYTHON" ]] || fail "Falta Python 3. Prepara dependencias: bash $LAB5_DIR/tools/setup_host.sh"
if ! "$PYTHON" -c 'import serial.tools.miniterm' >/dev/null 2>&1; then
    fail "Falta pyserial. Instálalo sin Zephyr con: bash $LAB5_DIR/tools/setup_host.sh"
fi
"$PYTHON" -m serial.tools.miniterm "$PORT" 115200 --raw
