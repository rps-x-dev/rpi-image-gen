[Unit]
Description=Application Service
After=network-online.target app-firstboot-setup.service
Wants=network-online.target

[Service]
EnvironmentFile=-/boot/firmware/app.conf
User=$APP_USER
WorkingDirectory=$APP_DIR
ExecStart=/bin/sh -lc "${APP_RUN:-$APP_RUN_CMD}"
Restart=always
RestartSec=3
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
