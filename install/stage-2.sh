#!/usr/bin/env bash
# Stage 2: run from the freshly booted throwaway system (stage 1 output),
# as brian. Applies the real flake configuration.
#
# Usage (download first — do NOT pipe into bash, the script reads stdin):
#   curl -fsSL https://raw.githubusercontent.com/brian-xu/.nixos/disko-btrfs/install/stage-2.sh -o /tmp/stage-2.sh
#   bash /tmp/stage-2.sh
#
# The sops age key is optional at this point (secrets.nix only activates
# secrets when /etc/age/keys.txt exists). If you skip it, SSH keys/secrets
# won't be provisioned until you stage the key and rebuild — run this script
# again after adding the key.
set -euo pipefail

REPO_DIR=${REPO_DIR:-$HOME/.nixos}
BRANCH=${BRANCH:-disko-btrfs}
AGE_KEY_FILE=/etc/age/keys.txt

if [[ $EUID -eq 0 ]]; then
  echo "Run as brian, not root (the script uses sudo where needed)." >&2
  exit 1
fi

# Read the age key from the terminal even if stdin is redirected.
read_key() {
  local keyfile=$1
  if [[ -t 0 ]]; then
    sudo tee "$keyfile" > /dev/null
  else
    sudo tee "$keyfile" > /dev/null < /dev/tty
  fi
  sudo chmod 600 "$keyfile"
}

if [[ -s $AGE_KEY_FILE ]]; then
  echo ">>> $AGE_KEY_FILE already exists, secrets will activate on rebuild"
elif [[ -t 0 ]]; then
  echo ">>> Optional: stage the sops age key now ($AGE_KEY_FILE)"
  echo "    Paste the key from Bitwarden, then press Enter and Ctrl-D."
  echo "    Or press Ctrl-D on an empty line to skip (add it later and re-run)."
  sudo mkdir -p /etc/age
  read_key "$AGE_KEY_FILE"
  if [[ -s $AGE_KEY_FILE ]]; then
    echo "    Key staged."
  else
    echo "    No key given — secrets will be skipped for now (fine)."
    sudo rm -f "$AGE_KEY_FILE"
  fi
else
  echo ">>> Skipping age key setup (not interactive). Secrets will be skipped."
  echo "    To enable later: sudo mkdir -p /etc/age && sudo tee $AGE_KEY_FILE, then re-run."
fi

# The stage-1 throwaway system does not include git. Use nix-shell when
# it is missing (requires nix-command/flakes, which stage 1 enables).
run_git() {
  if command -v git > /dev/null 2>&1; then
    git "$@"
  else
    nix-shell -p git --run "git $*"
  fi
}

echo ">>> Fetching the repo to $REPO_DIR (branch $BRANCH)"
if [[ -d $REPO_DIR/.git ]]; then
  echo "    $REPO_DIR already exists, updating"
  run_git -C "$REPO_DIR" fetch origin
  run_git -C "$REPO_DIR" checkout "$BRANCH"
  run_git -C "$REPO_DIR" reset --hard "origin/$BRANCH"
else
  run_git clone -b "$BRANCH" https://github.com/brian-xu/.nixos.git "$REPO_DIR"
fi

echo ">>> Applying the real system (builds onto disk-backed /nix)"
# The throwaway already sets substituters (stage 1), but pass them explicitly
# so substitution works even if stage 1 was run from an older script version.
sudo nixos-rebuild switch --flake "$REPO_DIR#framework" \
  --option substituters 'https://cache.nixos.org https://brian-xu.cachix.org https://niri.cachix.org' \
  --option trusted-public-keys 'cache.nixos.org-1:6NCHdD59X431o0gwWVrUeUlo4vQwJGtH0hFEEwPiW7g= brian-xu.cachix.org-1:Wc29LaxB/t3YjkXEDGMAcnBKYj8YqQl9pPs48nDcro4= niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964='

echo
echo "Stage 2 complete. Set your real password:"
echo "  passwd"
if [[ ! -s $AGE_KEY_FILE ]]; then
  echo
  echo "Age key not staged — secrets (SSH keys) are inactive. To enable later:"
  echo "  sudo mkdir -p /etc/age"
  echo "  sudo tee /etc/age/keys.txt   # paste key, Ctrl-D; chmod 600"
  echo "  sudo nixos-rebuild switch --flake ~/.nixos#framework"
fi
echo "Then add this host's key to .sops.yaml and re-encrypt secrets"
echo "(see README.md)."
