# an idiot's attempt at nixos

# 1. Clone config
git clone https://github.com/brian-xu/.nixos.git
sudo rm -rf /etc/nixos
ln -s ~/.nixos /etc/nixos

# 2. Restore personal age key from Bitwarden
sudo mkdir -p /etc/age
sudo tee /etc/age/keys.txt  # paste key from Bitwarden, Ctrl+D
sudo chmod 600 /etc/age/keys.txt

# 3. Rebuild — sops decrypts using the age key, places id_ed25519 at ~/.ssh/
sudo nixos-rebuild switch -I nixos-config=/home/brian/.nixos/configuration.nix

# 4. Add this host to .sops.yaml and re-encrypt so future rebuilds use the host key
ssh-to-age < /etc/ssh/ssh_host_ed25519_key.pub
# Add to .sops.yaml, then:
sops updatekeys /home/brian/.nixos/secrets/secrets.yaml
git -C /home/brian/.nixos add -A && git commit -m "add $(hostname) host key" && git push
