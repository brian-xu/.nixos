# Fresh install (minimal ISO + disko, two-stage)

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
git clone https://github.com/brian-xu/.nixos.git
cd .nixos
```

## 3. Partition, format, and mount with disko

```bash
bash install/stage-0.sh
reboot
```

## 4. Install the stage-1 system (the minimal throwaway config)

```bash
bash /tmp/.nixos/install/stage-1.sh
reboot
```

## 5. Build the real system on disk

Log in as `brian` / `install`, then run the stage-2 script:

```bash
git clone https://github.com/brian-xu/.nixos.git
cd .nixos
bash install/stage-2.sh
```