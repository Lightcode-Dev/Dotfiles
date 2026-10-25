#!/usr/bin/env bash
# power-profile.sh: cycle the power-profiles-daemon profile.
#   power-profile.sh        switch to the next available profile

set -uo pipefail

# Friendly names for notifications (performance is the "Overclocking" one)
label() {
    case "$1" in
        performance) echo "Overclocking" ;;
        balanced)    echo "Balanced" ;;
        power-saver) echo "Power saver" ;;
        *)           echo "$1" ;;
    esac
}

# Fire-and-forget notification: backgrounded and capped at 2 seconds
notify() { timeout 2 notify-send -u low "$1" "$2" >/dev/null 2>&1 & }

# The profiles the hardware offers, in the order `powerprofilesctl list` prints them.
# Matches only the profile header lines ("* performance:" / "  balanced:").
mapfile -t profiles < <(powerprofilesctl list | sed -n 's/^[* ] \([a-z-]*\):$/\1/p')

if [[ ${#profiles[@]} -lt 2 ]]; then
    notify "Power profile" "Only one profile is available"
    exit 0
fi

current="$(powerprofilesctl get)"

# Find the current profile's position and step to the next, wrapping around
next="${profiles[0]}"
for i in "${!profiles[@]}"; do
    if [[ "${profiles[$i]}" == "$current" ]]; then
        next="${profiles[$(( (i + 1) % ${#profiles[@]} ))]}"
        break
    fi
done

powerprofilesctl set "$next"
notify "Power profile" "$(label "$next")"
