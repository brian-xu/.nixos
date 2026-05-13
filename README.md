# an idiot's attempt at nixos

<img width="645" height="549" alt="image" src="https://github.com/user-attachments/assets/1456c3e4-4de8-44c0-bb3e-c08902f00fa2" />

## Structure

```
flake.nix
modules/
  nixos/
    hardware/framework-13/   # Framework 13 AMD 7040 overrides
    programs/                # zsh, micromamba, nix-ld
    services/                # KDE/SDDM, pipewire, tailscale, TLP
    security/                # openssh + sops age key config
  home/
    apps/                    # desktop apps with declarative configs
    desktop/plasma/          # KDE Plasma 6 settings
pkgs/
  ferrosonic/                # terminal music player derivation
  krohnkite/                 # kde tiling manager
systems/x86_64-linux/nixos/  # host config: boot, networking, users, sops secrets
homes/brian/    # user packages
secrets/                     # SOPS/age encrypted secrets (safe to commit)
```

## Setup

### 1. Clone config
```bash
git clone https://github.com/brian-xu/.nixos.git
sudo rm -rf /etc/nixos
ln -s ~/.nixos /etc/nixos
```

### 2. Restore personal age key from Bitwarden
```bash
sudo mkdir -p /etc/age
sudo tee /etc/age/keys.txt
sudo chmod 600 /etc/age/keys.txt
```

### 3. Rebuild — sops decrypts using the age key, places id_ed25519 at ~/.ssh/
```bash
sudo nixos-rebuild switch --flake .#nixos
```

### 4. Add this host to .sops.yaml and re-encrypt so future rebuilds use the host key
```bash
ssh-to-age < /etc/ssh/ssh_host_ed25519_key.pub
# Add to .sops.yaml, then:
sops updatekeys /home/brian/.nixos/secrets/secrets.yaml
git -C /home/brian/.nixos add -A && git commit -m "add $(hostname) host key" && git push
```

## Maintenance

### Update inputs
```bash
# Update all inputs to their latest commits
nix flake update

# Update a single input (e.g. nixpkgs only)
nix flake update nixpkgs
```

Then rebuild to apply: `sudo nixos-rebuild switch`
