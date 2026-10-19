#!/usr/bin/env bash
# cache-sync-verify.sh: sync the clone to branch HEAD, then verify the cache
# actually contains the closure at that HEAD.
#
# Resolves the disagreement where CI says "all paths pushed" but local probes
# 404: the usual cause is the local clone not being at the exact commit CI
# built (different flake.lock = different hashes = cache misses by design).
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/brian-xu/.nixos/disko-btrfs/install/cache-sync-verify.sh -o /tmp/csv.sh
#   bash /tmp/csv.sh
set -uo pipefail

REPO_DIR=${REPO_DIR:-$HOME/.nixos}
BRANCH=${BRANCH:-disko-btrfs}
SUDO=""
[[ $EUID -ne 0 ]] && SUDO="sudo"

line() { printf '\n===== %s =====\n' "$1"; }

line "1. Syncing $REPO_DIR to origin/$BRANCH"
if [[ ! -d $REPO_DIR/.git ]]; then
  echo "cloning..."
  nix-shell -p git --run "git clone -b $BRANCH https://github.com/brian-xu/.nixos.git $REPO_DIR"
else
  nix-shell -p git --run "git -C $REPO_DIR fetch origin && git -C $REPO_DIR checkout $BRANCH && git -C $REPO_DIR reset --hard origin/$BRANCH"
fi
HEAD=$(git -C "$REPO_DIR" rev-parse --short HEAD 2>/dev/null || nix-shell -p git --run "git -C $REPO_DIR rev-parse --short HEAD")
echo "local HEAD: $HEAD"

line "2. Resolve terraform at this HEAD (the hash that must be cached)"
DRV=$($SUDO nix eval --raw "$REPO_DIR#nixosConfigurations.framework.pkgs.terraform.outPath" 2>/dev/null || true)
if [[ -z $DRV ]]; then
  DRV=$(ls -d /nix/store/*-terraform-* 2>/dev/null | grep -v '\.drv' | head -1)
fi
if [[ -z $DRV ]]; then
  echo "could not resolve terraform; nothing to verify" >&2
  exit 1
fi
echo "terraform outPath: $DRV"
h=$(basename "$DRV" | sed 's/-.*//')

line "3. Probe caches for this exact hash"
c=$(curl -s -m 10 -o /dev/null -w '%{http_code}' "https://cache.nixos.org/$h.narinfo" || echo err)
x=$(curl -s -m 10 -o /dev/null -w '%{http_code}' "https://brian-xu.cachix.org/$h.narinfo" || echo err)
echo "cache.nixos.org -> $c"
echo "brian-xu.cachix.org -> $x"

line "4. Verdict"
if [[ $x == 200 ]]; then
  echo "VERDICT: cachix has this exact terraform. Rebuild and it substitutes:"
  echo "  sudo nixos-rebuild switch --flake $REPO_DIR#framework"
elif [[ $c == 200 ]]; then
  echo "VERDICT: cache.nixos.org has it (cachix does not; harmless). Rebuild:"
  echo "  sudo nixos-rebuild switch --flake $REPO_DIR#framework"
else
  echo "VERDICT: neither cache has the terraform built at HEAD $HEAD."
  echo "Compare this hash with CI's build logs (gh run view --log | grep terraform)."
  echo "If they differ, the local eval diverges from CI's (lockfile or channel"
  echo "state). If they match, the CI push step is not uploading — file that."
  echo "Local hash: $h"
fi
