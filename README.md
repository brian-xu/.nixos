# an idiot's attempt at nixos

<img width="645" height="549" alt="image" src="https://github.com/user-attachments/assets/1456c3e4-4de8-44c0-bb3e-c08902f00fa2" />

## Structure

```
flake.nix
modules/
  configs/                   # declarative configs
    apps/                    # app-specific configs
    desktops/                # de-specific configs
  programs/                  # generally useful programs
  services/                  # generic + power management services
  security/                  # openssh + sops age key config
lib/                         # library functions
pkgs/                        # custom package derivations
nixos/                       # basic linux/nix config options
homes/                       # user config via home-manager
hosts/                       # host config: hardware specific
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

### 3. Rebuild
```bash
sudo nixos-rebuild switch --flake ~/.nixos#framework
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

Then rebuild to apply: `nh os switch ~/.nixos#framework`

### Update NixOS version

```bash
nix-channel --add https://channels.nixos.org/latest nixos

nix-channel --update nixos
```

Then, update flake inputs and run
```
nix flake update
```

Finally, rebuild to apply: `nh os switch ~/.nixos#framework`
