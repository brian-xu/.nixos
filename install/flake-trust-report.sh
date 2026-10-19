#!/usr/bin/env bash
# flake-trust-report.sh: reproduce substituter warnings with the REAL flake
# build, not a toy. A plain nixpkgs#hello build exercises none of the flake
# paths (advertised caches, root re-invocation, env propagation) where the
# warnings actually come from.
#
# Usage (as brian, on the throwaway or real system):
#   curl -fsSL https://raw.githubusercontent.com/brian-xu/.nixos/disko-btrfs/install/flake-trust-report.sh -o /tmp/freport.sh
#   bash /tmp/freport.sh | tee /tmp/flake-trust-report.txt
set -uo pipefail

REPO_DIR=${REPO_DIR:-$HOME/.nixos}
TARGET="$REPO_DIR#nixosConfigurations.framework.config.system.build.toplevel"

line() { printf '\n===== %s =====\n' "$1"; }

line "Dry-run of the real flake target, as $(id -un)"
out=$(mktemp)
nix build --dry-run "$TARGET" 2>"$out" >/dev/null
echo "exit: $?"
echo "--- verbatim warnings/errors mentioning substituters, caches, trust ---"
grep -inE "ignor|substitut|not signed|trusted|cache" "$out" | sed 's/^/  /' || echo "(none)"
echo "--- full stderr preserved at $out ---"

line "Same dry-run as root (what nixos-rebuild sees)"
out2=$(mktemp)
sudo -i nix build --dry-run "$TARGET" 2>"$out2" >/dev/null
echo "exit: $?"
grep -inE "ignor|substitut|not signed|trusted" "$out2" | sed 's/^/  /' || echo "(none)"
echo "--- full stderr preserved at $out2 ---"

line "Same dry-run as root with stage-2's NIX_CONFIG"
out3=$(mktemp)
sudo env NIX_CONFIG="substituters = https://cache.nixos.org https://brian-xu.cachix.org https://niri.cachix.org
trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gwWVrUeUlo4vQwJGtH0hFEEwPiW7g= brian-xu.cachix.org-1:Wc29LaxB/t3YjkXEDGMAcnBKYj8YqQl9pPs48nDcro4= niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964=" \
  nix build --dry-run "$TARGET" 2>"$out3" >/dev/null
echo "exit: $?"
grep -inE "ignor|substitut|not signed|trusted" "$out3" | sed 's/^/  /' || echo "(none)"
echo "--- full stderr preserved at $out3 ---"

line "Effective config seen by each invocation"
echo "-- as $(id -un):"
nix show-config 2>/dev/null | grep -E '^substituters ' | sed 's/^/  /'
echo "-- as root (login shell):"
sudo -i nix show-config 2>/dev/null | grep -E '^substituters ' | sed 's/^/  /'
echo "-- as root with stage-2 NIX_CONFIG:"
sudo env NIX_CONFIG="substituters = https://cache.nixos.org https://brian-xu.cachix.org https://niri.cachix.org" \
  nix show-config 2>/dev/null | grep -E '^substituters ' | sed 's/^/  /'

line "Interpretation"
cat <<'EOF'
Compare the three dry-runs. The one that matches stage-2's behavior
(as-root + NIX_CONFIG) is the live configuration:

- Warnings only in the flake builds, not the toy: they come from a flake
  source (advertised caches in inputs' metadata). If downloads still
  happen (the dry-run shows 'will be fetched'), these warnings are noise.
- Warnings only as root: root's own config differs — check the
  'as root' effective substituters line above.
- 'will be fetched' vs 'will be built' in the matched run is the real
  verdict: fetched = substitution works despite warnings.
EOF
