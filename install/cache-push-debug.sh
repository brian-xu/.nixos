#!/usr/bin/env bash
# cache-push-debug.sh: push the closure to brian-xu.cachix.org with full
# visibility — auth state, per-path decisions, and narinfo verification —
# and diagnose the failure class from its own output.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/brian-xu/.nixos/disko-btrfs/install/cache-push-debug.sh -o /tmp/cpd.sh
#   bash /tmp/cpd.sh
set -uo pipefail

REPO_DIR=${REPO_DIR:-$HOME/.nixos}
HOST=${HOST:-framework}
CACHE=${CACHE:-brian-xu}

line() { printf '\n===== %s =====\n' "$1"; }

line "1. Build the toplevel (instant if already built)"
OUT=$(mktemp -d)
nix build "$REPO_DIR#nixosConfigurations.$HOST.config.system.build.toplevel" --out-link "$OUT/result" || exit 1
TOP=$(readlink -f "$OUT/result")
echo "toplevel: $TOP"

line "2. Auth state"
nix-shell -p cachix --run "cachix --version"
if [[ -n ${CACHIX_AUTH_TOKEN:-} ]]; then
  echo "CACHIX_AUTH_TOKEN: set in environment"
else
  echo "CACHIX_AUTH_TOKEN: not set"
  echo "auth file: $(nix-shell -p cachix --run 'ls ~/.config/cachix/cachix.dhall' 2>/dev/null || echo 'missing')"
fi

line "3. Push (verbose — shows per-path decisions)"
nix-shell -p cachix --run "cachix push $CACHE $OUT/result -v" 2>&1 | tee /tmp/cachix-push.log | tail -30
push_status=$?

line "4. Verify deep closure members actually landed"
fail=0
for p in "$TOP" \
         $(nix-store -q --requisites "$TOP" 2>/dev/null | grep -m1 terraform) \
         $(nix-store -q --requisites "$TOP" 2>/dev/null | grep -m1 home-manager-path); do
  [ -z "$p" ] && continue
  h=$(basename "$p" | sed 's/-.*//')
  code=$(curl -s -m 10 -o /dev/null -w '%{http_code}' "https://$CACHE.cachix.org/$h.narinfo")
  echo "  $h -> $code  ($(basename "$p" | sed 's/^[a-z0-9]*-//'))"
  [ "$code" = "200" ] || fail=1
done

line "5. Diagnosis"
if grep -qi "unauthorized\|authenticate\|401" /tmp/cachix-push.log; then
  echo "AUTH FAILURE: local cachix has no valid token."
  echo "Fix: cachix authtoken <token from https://brian-xu.cachix.org> (Settings), then re-run."
elif grep -qi "nothing to push" /tmp/cachix-push.log && [[ $fail == 1 ]]; then
  echo "PARADOX: push says 'nothing to push' but the cache lacks the paths."
  echo "This falsifies the daemon theory locally — likely a cache-service"
  echo "inconsistency. Report to Cachix with /tmp/cachix-push.log. Workaround:"
  echo "try: nix-shell -p cachix --run 'cachix push $CACHE \$(nix-store -q --requisites $TOP) -v'"
elif [[ $fail == 0 ]]; then
  echo "SUCCESS: toplevel, terraform, and home-manager-path all probe 200."
  echo "Rebuild now substitutes: sudo nixos-rebuild switch --flake $REPO_DIR#$HOST"
else
  echo "PUSH INCOMPLETE (exit $push_status, verification failed)."
  echo "Full log: /tmp/cachix-push.log — the last 30 lines are above."
fi
