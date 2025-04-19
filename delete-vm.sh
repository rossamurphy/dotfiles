#!/bin/bash

set -euo pipefail

if [ -z "${1:-}" ]; then
  echo "Usage: $0 <vm-name>"
  exit 1
fi

VM_NAME="$1"
ZONE="europe-west1-b"
DATA_DISK_NAME="${VM_NAME}-data-disk"
SSH_DIR="$HOME/.ssh"
KEY_PATH="$SSH_DIR/$VM_NAME"

echo "🗑️  Deleting VM '$VM_NAME' in zone '$ZONE'..."
gcloud compute instances delete "$VM_NAME" --zone="$ZONE" --quiet

echo "💽 Deleting disk '$DATA_DISK_NAME'..."
gcloud compute disks delete "$DATA_DISK_NAME" --zone="$ZONE" --quiet || echo "(disk already deleted)"

# Delete local SSH keys
if [ -f "$KEY_PATH" ]; then
  echo "🧹 Deleting SSH key $KEY_PATH"
  rm -f "$KEY_PATH"
fi

if [ -f "$KEY_PATH.pub" ]; then
  echo "🧹 Deleting SSH pub key $KEY_PATH.pub"
  rm -f "$KEY_PATH.pub"
fi

echo "✅ Cleanup complete for '$VM_NAME'"

