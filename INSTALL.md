# Fresh install (minimal ISO + disko, two-stage)

The full system closure (~20 GB) does not fit the installer ISO's RAM-backed
`/nix` store, so installation happens in two stages:

1. **Stage 1** — partition with disko, install a minimal throwaway system with
   `nixos-install` (small closure, fits in RAM).
2. **Stage 2** — from the booted throwaway system, where `/nix` lives on disk,
   apply the real flake with `nixos-rebuild switch`.

## 1. Boot the minimal ISO

* Download the [minimal ISO image](https://nixos.org/download) for x86_64
* Write it to a [USB drive](https://nixos.org/manual/nixos/stable/index.html#sec-booting-from-usb)
* Boot from it, log in as root (`sudo -i`)

> [!NOTE] For wifi, run the following command:
> ```bash
> nmcli device wifi connect "<ssid>" password <pass>
> ```

## 2. Clone the repo

```bash
git clone -b disko-btrfs https://github.com/brian-xu/.nixos.git /tmp/.nixos
```

## 3. Partition, format, and mount with disko

```bash
nix --experimental-features "nix-command flakes" \
  run 'github:nix-community/disko/latest' -- \
  --mode destroy,format,mount \
  /tmp/.nixos/hosts/framework-13/disko.nix
```

Notes:

* disko mode names changed: old `--mode disko` is now `--mode
  destroy,format,mount`, old `zap_create_mount` likewise. Plain `--mode
  format` is idempotent ("create if not exists") and will *not* remove stale
  subvolumes from a previous attempt — always include `destroy` when starting
  over.
* You will be prompted for the LUKS passphrase.
* Verify the result before continuing:
  ```bash
  lsblk -f /dev/nvme0n1          # p1 vfat, p2 swap, p3 LUKS -> crypted btrfs
  btrfs subvolume show /mnt       # Path: root
  btrfs subvolume list /mnt       # root, home, nix
  mount | grep btrfs              # subvol=/root, /home, /nix
  ```

## 4. Install the minimal throwaway system

Run the stage-1 script (it writes the hand-rolled hardware config — the layout
is fully determined by `disko.nix`, so `nixos-generate-config` is not needed —
plus a minimal `configuration.nix`, then runs `nixos-install`):

```bash
bash /tmp/.nixos/install/stage-1.sh
reboot
```

## 5. First boot — apply the real system

Log in as `brian` / `install`, then run the stage-2 script:

```bash
bash /tmp/.nixos/install/stage-2.sh   # if the repo was cloned to /tmp on the ISO
# or, if not:
curl -fsSL https://raw.githubusercontent.com/brian-xu/.nixos/disko-btrfs/install/stage-2.sh | bash
```

Stage 2 runs with a disk-backed `/nix`, and the flake's substituters
(`brian-xu.cachix.org`, `niri.cachix.org`) are in effect for the first time.

* Add this host's key to `.sops.yaml` and re-encrypt so future rebuilds use
  the host key (see [Setup](README.md#4-add-this-host-to-sopsyaml-and-re-encrypt-so-future-rebuilds-use-the-host-key)).

## Troubleshooting

* **`No space left on device` while building** — the ISO's `/nix/store` upper
  layer (`/nix/.rw-store`) is a tmpfs capped at ~half your RAM; a full desktop
  closure will not fit. That is what the two-stage flow avoids. Do not use
  `disko-install` with `#framework` from the ISO unless you have 64 GB+ RAM
  (a `framework-install` minimal host variant exists in the flake for
  low-memory installs if you prefer disko-install).
* **Substituters during install** — the flake's `nix.settings` does not apply
  to the installer's Nix daemon. If you need caches during an ISO-side build,
  pass them explicitly:
  ```bash
  ... --option substituters 'https://cache.nixos.org https://brian-xu.cachix.org https://niri.cachix.org' \
      --option trusted-public-keys 'cache.nixos.org-1:6NCHdD59X431o0gwWVrUeUlo4vQwJGtH0hFEEwPiW7g= brian-xu.cachix.org-1:Wc29LaxB/t3YjkXEDGMAcnBKYj8YqQl9pPs48nDcro4= niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964='
  ```
* **Stale subvolume state after a failed attempt** — re-run disko with
  `--mode destroy,format,mount` (not just `format`).
* **Half-completed disko run left mounts behind** — `--mode unmount` unwinds
  them cleanly.
