#!/usr/bin/env bash
# verdict.sh: one-sentence diagnosis of "not substituting from cache".
# No interpretation needed — prints exactly one action.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/brian-xu/.nixos/disko-btrfs/install/verdict.sh -o /tmp/verdict.sh
#   bash /tmp/verdict.sh
set -uo pipefail

REPO_DIR=${REPO_DIR:-$HOME/.nixos}
SUDO=""
[[ $EUID -ne 0 ]] && SUDO="sudo"

# Resolve terraform's outPath from the flake's own nixpkgs input — the same
# pin the rebuild uses — rather than the registry ref (which can fail to
# resolve on a minimal system and mismatches the build anyway).
DRV=$($SUDO nix eval --raw "$REPO_DIR#nixosConfigurations.framework.pkgs.terraform.outPath" 2>/dev/null \
  || $SUDO nix eval --raw "$REPO_DIR#nixosConfigurations.framework.config.environment.systemPackages" 2>/dev/null \
  | tr ',' '\n' | grep -o '/nix/store/[a-z0-9]*-terraform[^"]*' | head -1)

if [[ -z $DRV ]]; then
  # Fallback: use any already-built terraform in the store; else hello as a
  # stock-package proxy for cache.nixos.org health.
  DRV=$(ls -d /nix/store/*-terraform-* 2>/dev/null | grep -v '\.drv' | head -1)
fi
if [[ -z $DRV ]]; then
  DRV=$($SUDO nix eval --raw nixpkgs#hello.outPath 2>/dev/null || true)
  NAME=hello
else
  NAME=terraform
fi

if [[ -z $DRV ]]; then
  echo "VERDICT: cannot evaluate packages on this system; run stage-2/rebuild first, then retry."
  exit 1
fi

h=$(basename "$DRV" | sed 's/-.*//')
code=$(curl -s -m 10 -o /dev/null -w '%{http_code}' "https://cache.nixos.org/$h.narinfo" || echo err)

# Config health: all three keys present in root's effective config?
keys_ok=true
for kid in cache.nixos.org-1 brian-xu.cachix.org-1 niri.cachix.org-1; do
  $SUDO nix show-config 2>/dev/null | grep -q "$kid" || keys_ok=false
done

# Daemon freshness: did nix.conf change after the daemon started?
conf_mtime=$(stat -c %Y /etc/nix/nix.conf 2>/dev/null || echo 0)
daemon_start=$(systemctl show nix-daemon -p ActiveEnterTimestampSec 2>/dev/null | cut -d= -f2)
stale=false
if [[ -n $daemon_start && $daemon_start != 0 ]] && (( conf_mtime > daemon_start )); then
  stale=true
fi

echo "probe: $NAME  cache.nixos.org -> $code  keys_ok=$keys_ok  daemon_stale=$stale"
echo
if [[ $stale == true ]]; then
  echo "VERDICT: the nix daemon is running stale config. Run: sudo systemctl restart nix-daemon && sudo nixos-rebuild switch --flake $REPO_DIR#framework"
elif [[ $keys_ok == false ]]; then
  echo "VERDICT: /etc/nix/nix.conf is missing cache keys. Run: bash /tmp/doctor.sh --fix   then rebuild."
elif [[ $code == 200 ]]; then
  echo "VERDICT: the cache has your package and config looks fine — substitution should work. If the rebuild still builds locally, run it plainly (no NIX_CONFIG, no --option): sudo nixos-rebuild switch --flake $REPO_DIR#framework"
elif [[ $code == 404 ]]; then
  echo "VERDICT: nothing is broken — cache.nixos.org genuinely lacks this exact build (your nixpkgs pin is newer than hydra's queue). Let it build locally once, then run cache-push.sh so it never builds again."
else
  echo "VERDICT: network/probe error ($code) reaching cache.nixos.org — check connectivity, then retry."
fi
