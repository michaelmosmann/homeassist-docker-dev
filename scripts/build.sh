#!/usr/bin/env bash
set -euo pipefail

INTEGRATION_DIR="src/custom_components"
INTEGRATION_NAME=$(ls "$INTEGRATION_DIR" | head -1)
MANIFEST="$INTEGRATION_DIR/$INTEGRATION_NAME/manifest.json"
VERSION=$(python3 -c "import json; print(json.load(open('$MANIFEST'))['version'])")

DIST_DIR="dist"
ARTIFACT="$DIST_DIR/${INTEGRATION_NAME}-${VERSION}.zip"

mkdir -p "$DIST_DIR"
rm -f "$ARTIFACT"

(cd src && zip -r "../$ARTIFACT" "custom_components/$INTEGRATION_NAME" \
    -x "**/__pycache__/*" \
    -x "**/*.pyc" \
    -x "**/*.pyo")

echo "Built: $ARTIFACT"
