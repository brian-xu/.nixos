#!/usr/bin/env bash
# cache-check.sh: figure out why a build is not substituting from cachix.
#
# Answers three questions with evidence:
#  1. Is the effective Nix config actually using the substituters?
#  2. Are the paths this build needs present in each cache? (narinfo probe)
#  3. What did the last/next build actually do? (log tally helpers)
#
# Usage (any user; uses sudo where needed):
#   curl -fsSL https://raw.githubusercontent.com/brian-xu/.nixos/disko-btrfs/install/cache-check.sh -o /tmp/cache-check.sh
#   bash /tmp/cache-check.sh
set -euo pipefail

REPO_DIR=${REPO_DIR:-$HOME/.nixos}
HOST=${HOST:-framework}

SUDO=""
[[ $EUID -ne 0 ]] && SUDO="sudo"

echo "== 1. Effective substituter config (daemon view) =="
$SUDO nix show-config 2>/dev/null | grep -E '^(substituters|trusted-public-keys|trusted-users) ' || echo "  (nix show-config unavailable)"

echo
echo "== 2. Cache population probe =="
TOP=$($SUDO nix path-info "$REPO_DIR#nixosConfigurations.$HOST.config.system.build.toplevel" 2>/dev/null | head -1 || true)
if [[ -z $TOP ]]; then
  echo "  (could not resolve toplevel path — is $REPO_DIR present and evaluated?)"
else
  echo "  toplevel: $TOP"
  # Sample hashes from the closure: the toplevel itself plus a random-ish slice.
  mapfile -t PATHS < <($SUDO nix path-info --derivation "$REPO_DIR#nixosConfigurations.$HOST.config.system.build.toplevel" 2>/dev/null | head -5 || true)
  mapfile -t CLOSURE < <($SUDO nix-store -q --requisites "$TOP" 2>/dev/null | head -40)
  for p in "${PATHS[@]}" "${CLOSURE[@]:8:4}"; do
    h=$(basename "$p" | sed 's/-.*//')
    name=$(basename "$p" | sed 's/^[a-z0-9]*-//')
    [[ $h =~ ^[a-z0-9]{32}$ ]] || continue
    b=$(curl -s -m 10 -o /dev/null -w '%{http_code}' "https://brian-xu.cachix.org/$h.narinfo" || echo err)
    c=$(curl -s -m 10 -o /dev/null -w '%{http_code}' "https://cache.nixos.org/$h.narinfo" || echo err)
    n=$(curl -s -m 10 -o /dev/null -w '%{http_code}' "https://niri.cachix.org/$h.narinfo" || echo err)
    echo "  $name"
    echo "    brian-xu.cachix.org: $b   cache.nixos.org: $c   niri.cachix.org: $n   (200=in cache, 404=missing)"
  done
fi

echo
echo "== 3. Next-build plan (dry run summary) =="
$SUDO nix build "$REPO_DIR#nixosConfigurations.$HOST.config.system.build.toplevel" --dry-run 2>&1 \
  | grep -E 'will be built|will be fetched|nothing to be done' || true

echo
echo "If brian-xu.cachix.org probes return 404: the cache simply does not"
echo "contain these paths — push them after a successful build with:"
echo "  nix build $REPO_DIR#nixosConfigurations.$HOST.config.system.build.toplevel"
echo "  nix-shell -p cachix --run 'cachix push brian-xu ./result'"
