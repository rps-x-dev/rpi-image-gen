[Unit]
Description=First-boot: setup app (clone/build/configure)
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/local/sbin/app-firstboot-setup
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
