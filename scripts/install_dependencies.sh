
#!/bin/bash
set -euo pipefail

APP_DIR="/opt/flask-cicd"
VENV_DIR="${APP_DIR}/venv"

echo "Installing Flask application dependencies..."

cd "${APP_DIR}"

# Verify required files exist.
test -f app.py
test -f requirements.txt

# Find the available Python 3 executable.
if command -v python3 >/dev/null 2>&1; then
    PYTHON_BIN="$(command -v python3)"
else
    echo "ERROR: python3 is not installed."
    exit 1
fi

# Create the virtual environment if necessary.
if [ ! -x "${VENV_DIR}/bin/python" ]; then
    "${PYTHON_BIN}" -m venv "${VENV_DIR}"
fi

"${VENV_DIR}/bin/python" -m pip install --upgrade pip
"${VENV_DIR}/bin/python" -m pip install -r requirements.txt

echo "Dependencies installed successfully."
