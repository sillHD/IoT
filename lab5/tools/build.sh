#!/usr/bin/env bash
set -euo pipefail
source "$(dirname -- "${BASH_SOURCE[0]}")/common.sh"
[[ $# -ge 1 && $# -le 2 ]] || fail "Uso: build.sh S|C [uart|usb]; RCP; BR N16R8"
select_target "$@"
setup_workspace
cmake_args=()
case "$ROLE" in
    S|C)
        cmake_args+=("-DDTC_OVERLAY_FILE=$SOURCE_DIR/boards/esp32c6_devkitc_hpcore.overlay")
        overlays=()
        [[ "$ROLE" == S ]] && overlays+=("$SOURCE_DIR/sensors/ds18b20.overlay")
        if [[ "$CONSOLE" == usb ]]; then
            overlays+=("$SOURCE_DIR/usb_console.overlay")
            cmake_args+=("-DEXTRA_CONF_FILE=$SOURCE_DIR/usb_console.conf")
        fi
        if [[ ${#overlays[@]} -gt 0 ]]; then
            overlay_list="$(IFS=';'; printf '%s' "${overlays[*]}")"
            cmake_args+=("-DEXTRA_DTC_OVERLAY_FILE=$overlay_list")
        fi
        ;;
    RCP)
        cmake_args+=("-DDTC_OVERLAY_FILE=$SOURCE_DIR/boards/esp32c6_devkitc_hpcore.overlay")
        ;;
    BR)
        cmake_args+=("-DDTC_OVERLAY_FILE=$SOURCE_DIR/boards/esp32s3_devkitc_procpu.overlay")
        cmake_args+=("-DEXTRA_DTC_OVERLAY_FILE=$SOURCE_DIR/boards/flash8.overlay")
        # Explicitly include the upstream octal PSRAM profile; do not rely on board filename discovery.
        cmake_args+=("-DEXTRA_CONF_FILE=$SOURCE_DIR/boards/esp32s3_devkitc_procpu.conf")
        ;;
esac
mkdir -p "$LAB5_DIR/evidencias/archivos"
rm -f -- "$BUILD_DIR/iot-lab5-target.txt"
west build -p always -b "$BOARD" -s "$SOURCE_DIR" -d "$BUILD_DIR" \
    -- "${cmake_args[@]}" 2>&1 | tee "$LAB5_DIR/evidencias/archivos/build-$BUILD_LABEL.log"
require_config "CONFIG_FLASH_SIZE=$FLASH_KB"
case "$ROLE" in
    S|C) require_config 'CONFIG_OPENTHREAD_SLAAC=y' ;;
    RCP) require_config 'CONFIG_OPENTHREAD_COPROCESSOR_RCP=y' ;;
    BR) require_config 'CONFIG_ESP_SPIRAM=y'; require_config 'CONFIG_SPIRAM_MODE_OCT=y'; require_config 'CONFIG_OPENTHREAD_SETTINGS_RAM=y' ;;
esac
[[ -f "$BUILD_DIR/zephyr/zephyr.bin" ]] || fail "No se generó zephyr.bin."
artifact_sha="$(sha256sum "$BUILD_DIR/zephyr/zephyr.bin")"
printf '%s\n%s\n' "$BUILD_LABEL" "${artifact_sha%% *}" > "$BUILD_DIR/iot-lab5-target.txt"
printf '\nGenerado para %s: %s/zephyr/zephyr.bin\n' "$BUILD_LABEL" "$BUILD_DIR"
