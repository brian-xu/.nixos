#!/usr/bin/env bash
set -euo pipefail

MNT=/mnt
REPO_DIR=${REPO_DIR:-$(cd "$(dirname "$0")/.." && pwd)}

if [[ $EUID -ne 0 ]]; then
  echo "Run as root (sudo -i) from the installer ISO." >&2
  exit 1
fi

if ! mountpoint -q "$MNT"; then
  echo "$MNT is not a mountpoint." >&2
  echo "Run disko first, e.g.:" >&2
  echo "  nix --experimental-features 'nix-command flakes' \\"
  echo "    run 'github:nix-community/disko/latest' -- \\"
  echo "    --mode destroy,format,mount $REPO_DIR/hosts/framework-13/disko.nix" >&2
  exit 1
fi

if ! grep -q 'brian-xu.cachix.org' /etc/nix/nix.conf 2>/dev/null; then
  echo ">>> Pointing the ISO's Nix at the caches"
  # /etc/nix is on the ISO's read-only layer, so write a new nix.conf and
  # bind-mount it over /etc/nix where the daemon reads it, then restart the
  # daemon (same approach as stage-2.sh; NIX_CONFIG alone is client-side
  # and the daemon ignores untrusted substituters).
  mkdir -p /tmp/nix-conf.d
  cp -a /etc/nix/. /tmp/nix-conf.d/ 2>/dev/null || true
  cat > /tmp/nix-conf.d/nix.conf <<'EOF'
substituters = https://cache.nixos.org https://brian-xu.cachix.org https://niri.cachix.org
trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gwWVrUeUlo4vQwJGtH0hFEEwPiW7g= brian-xu.cachix.org-1:Wc29LaxB/t3YjkXEDGMAcnBKYj8YqQl9pPs48nDcro4= niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964=
trusted-users = root
experimental-features = nix-command flakes
EOF
  mount --bind /tmp/nix-conf.d /etc/nix
  systemctl restart nix-daemon
fi

echo ">>> Installing the stage-1 system from the flake (framework-install)"
nixos-install --root "$MNT" --no-root-password --flake "$REPO_DIR#framework-install"

echo
echo "Stage 1 complete. Reboot (remove the USB), unlock LUKS, log in as brian/install,"
echo "then run stage 2:"
echo "  curl -fsSL https://raw.githubusercontent.com/brian-xu/.nixos/install/stage-2.sh | bash"
echo "(or clone the repo and run: bash install/stage-2.sh)"
