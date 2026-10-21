
#!/bin/bash
set -euo pipefail

SERVICE_NAME="flask-cicd"

echo "Stopping ${SERVICE_NAME}..."

if systemctl is-active --quiet "${SERVICE_NAME}"; then
    systemctl stop "${SERVICE_NAME}"
    echo "Service stopped successfully."
else
    echo "Service is not running; nothing to stop."
fi

exit 0
