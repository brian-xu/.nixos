#!/usr/bin/env bash
# cache-push.sh: build the framework toplevel and push the closure to
# brian-xu.cachix.org, so future builds substitute instead of compiling.
#
# Run this after any successful rebuild that built things locally.
#
# Usage (as brian, on the real system or throwaway):
#   curl -fsSL https://raw.githubusercontent.com/brian-xu/.nixos/disko-btrfs/install/cache-push.sh -o /tmp/cache-push.sh
#   bash /tmp/cache-push.sh
set -euo pipefail

REPO_DIR=${REPO_DIR:-$HOME/.nixos}
HOST=${HOST:-framework}
CACHE=${CACHE:-brian-xu}

if [[ ! -d $REPO_DIR/.git ]]; then
  echo ">>> $REPO_DIR missing — set REPO_DIR or clone first" >&2
  exit 1
fi

echo ">>> Building $REPO_DIR#nixosConfigurations.$HOST.config.system.build.toplevel"
OUT=$(mktemp -d)
nix build "$REPO_DIR#nixosConfigurations.$HOST.config.system.build.toplevel" --out-link "$OUT/result"

echo ">>> Pushing closure to $CACHE (uploads only paths the cache lacks)"
nix-shell -p cachix --run "cachix push $CACHE $OUT/result"

echo ">>> Done. The cache now covers this closure; rebuilds will substitute."
rm -f "$OUT/result"
