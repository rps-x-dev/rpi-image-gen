Quickstart: first-boot app pull/build/run

What this example does
- Sets the Pi hostname from config (and lets you override it later).
- On first boot, pulls your project from a URL, builds it, and starts it as a service.
- You can change APP_URL and HOSTNAME after flashing by editing /boot/firmware/app.conf on the SD card.

Layout
  examples/firstboot_app/
  ├─ config/
  │  └─ pi5-firstboot.yaml        # Sample config for Raspberry Pi 5
  ├─ layer/
  │  └─ firstboot-app.yaml        # Layer adding first-boot clone/build/run
  ├─ app-firstboot-setup.service.tpl
  └─ app.service.tpl

Build an image
- For Pi 5 (edit hostname and defaults inside config if you want):
  rpi-image-gen build -S ./examples/firstboot_app -c pi5-firstboot.yaml

- You can override at build time too (optional):
  rpi-image-gen build -S ./examples/firstboot_app -c pi5-firstboot.yaml \
    OVR IGconf_device_hostname=my-pi \
    OVR IGconf_app_url=https://github.com/you/your-project.git \
    OVR IGconf_app_run='bash run.sh' \
    OVR IGconf_app_build='make -j$(nproc)'

Flash
- The built image appears under the output directory printed at the end of the build.
- Flash it to an SD card using your preferred method.

Edit values after flashing (but before first boot)
- Mount the small boot partition (FAT) on your PC and create/edit this file:
  /boot/firmware/app.conf
  Example content:
    HOSTNAME=my-pi
    APP_URL=https://github.com/you/your-project.git
    APP_BUILD=make -j$(nproc)
    APP_RUN=bash run.sh

First boot
- The Pi will:
  1) Set the hostname (if HOSTNAME is set in app.conf).
  2) Clone APP_URL into /opt/app (or pull if already there).
  3) Run APP_BUILD if provided.
  4) Start the app via systemd (service name: app.service).

Logs and troubleshooting
- View setup logs:    journalctl -u app-firstboot-setup -b
- View app logs:      journalctl -u app -f
- Rerun setup:        sudo rm -f /var/lib/app-firstboot.done && sudo systemctl restart app-firstboot-setup
- Adjust packages:    Edit layer/firstboot-app.yaml packages list if your project needs extra build deps.
