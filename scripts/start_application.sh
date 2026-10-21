
#!/bin/bash
set -euo pipefail

APP_DIR="/opt/flask-cicd"
VENV_DIR="${APP_DIR}/venv"
SERVICE_NAME="flask-cicd"

echo "Configuring and starting ${SERVICE_NAME}..."

test -x "${VENV_DIR}/bin/gunicorn"
test -f "${APP_DIR}/app.py"

cat > "/etc/systemd/system/${SERVICE_NAME}.service" <<EOF
[Unit]
Description=Flask CI/CD Application
After=network.target

[Service]
Type=simple
WorkingDirectory=${APP_DIR}
ExecStart=${VENV_DIR}/bin/gunicorn --workers 2 --bind 0.0.0.0:5000 app:app
Restart=on-failure
RestartSec=5
Environment=PYTHONUNBUFFERED=1

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable "${SERVICE_NAME}"
systemctl restart "${SERVICE_NAME}"

# Wait for the application to become ready.
for i in $(seq 1 30); do
    if curl --fail --silent http://127.0.0.1:5000/ >/dev/null; then
        echo "Application started successfully."
        exit 0
    fi
    sleep 2
done

echo "ERROR: Flask application failed its local health check."
journalctl -u "${SERVICE_NAME}" --no-pager -n 50 || true
exit 1
