# Fresh install (minimal ISO + disko)

Adapted from the [nixos.asia disko tutorial](https://nixos.asia/en/nixos-install-disko).

## 1. Boot the minimal ISO

* Download the [minimal ISO image](https://nixos.org/download) for x86_64
* Write it to a [USB drive](https://nixos.org/manual/nixos/stable/index.html#sec-booting-from-usb)
* Boot from it, log in as root (`sudo -i`)

> [!NOTE] For wifi, run the following command:
> ```bash
> nmcli device wifi connect "<ssid>" password <pass>
> ```

## 2. Clone the repo and stage files for the target system

```bash
git clone https://github.com/brian-xu/.nixos.git /tmp/.nixos

mkdir -p /tmp/staging/etc/age /tmp/staging/home/brian

# sops age key from Bitwarden — needed to decrypt secrets during activation
tee /tmp/staging/etc/age/keys.txt   # paste key, Ctrl-D
chmod 600 /tmp/staging/etc/age/keys.txt

# persist the config into ~ so no reclone is needed after reboot
cp -a /tmp/.nixos /tmp/staging/home/brian/.nixos
ln -s /home/brian/.nixos /tmp/staging/etc/nixos
chown -R 1000:100 /tmp/staging/home   # brian:users (only normal user, so uid 1000)
```

## 3. Partition and install (one command)

```bash
nix --experimental-features "nix-command flakes" \
  run 'github:nix-community/disko/latest#disko-install' -- \
  --write-efi-boot-entries \
  --flake '/tmp/.nixos#framework' \
  --disk nvme0n1 /dev/nvme0n1 \
  --system-config '{"users":{"users":{"brian":{"initialPassword":"install"}}}}' \
  --extra-files /tmp/staging/etc/age/keys.txt /etc/age/keys.txt \
  --extra-files /tmp/staging/etc/nixos /etc/nixos \
  --extra-files /tmp/staging/home/brian /home/brian
```

## 4. First boot

- Log in as `brian` with the initial password from step 3, then change it with `passwd`.
- Add this host's key to `.sops.yaml` and re-encrypt so future rebuilds use the host key (see [Setup](README.md#4-add-this-host-to-sopsyaml-and-re-encrypt-so-future-rebuilds-use-the-host-key)).
