#!/bin/bash

set -euo pipefail

if [ -z "${1:-}" ]; then
  echo "Usage: $0 <vm-name>"
  exit 1
fi

VM_NAME="$1"
ZONE="europe-west1-b"
MACHINE_TYPE="e2-medium"
IMAGE_FAMILY="debian-11"
IMAGE_PROJECT="debian-cloud"
SSH_DIR="$HOME/.ssh"
KEY_PATH="$SSH_DIR/$VM_NAME"
USERNAME="rossmurphy"
FIREWALL_RULE_NAME="allow-mosh-udp"
FIREWALL_TAG="mosh-enabled"
MOSH_PORTS="60000-60010"
SSH_PORTS="22"
BOOT_DISK_SIZE="20GB"
DATA_DISK_NAME="${VM_NAME}-data-disk"
DATA_DISK_SIZE="150GB"

# Generate SSH key if it doesn't already exist
if [ ! -f "$KEY_PATH" ]; then
  echo "🔑 Generating SSH key at $KEY_PATH"
  ssh-keygen -t rsa -f "$KEY_PATH" -C "$USERNAME" -N ""
fi

# Create firewall rule if it doesn't exist
if ! gcloud compute firewall-rules describe "$FIREWALL_RULE_NAME" &>/dev/null; then
  echo "🌐 Creating firewall rule $FIREWALL_RULE_NAME"
  gcloud compute firewall-rules create "$FIREWALL_RULE_NAME" \
    --direction=INGRESS \
    --priority=1000 \
    --network=default \
    --action=ALLOW \
    --rules=udp:$MOSH_PORTS \
    --source-ranges=0.0.0.0/0 \
    --target-tags="$FIREWALL_TAG"
fi

# Create Docker SSH firewall rule if it doesn't exist
DOCKER_SSH_RULE_NAME="allow-docker-ssh"
if ! gcloud compute firewall-rules describe "$DOCKER_SSH_RULE_NAME" &>/dev/null; then
  echo "🌐 Creating firewall rule $DOCKER_SSH_RULE_NAME"
  gcloud compute firewall-rules create "$DOCKER_SSH_RULE_NAME" \
    --direction=INGRESS \
    --priority=1000 \
    --network=default \
    --action=ALLOW \
    --rules=tcp:$DOCKER_SSH_PORT \
    --source-ranges=0.0.0.0/0 \
    --target-tags="$FIREWALL_TAG"
fi

# Format SSH key for metadata
PUBKEY_CONTENT="$(cat "$KEY_PATH.pub")"
METADATA_ENTRY="${USERNAME}:${PUBKEY_CONTENT} ${USERNAME}"

# Define startup script (mosh + ssh)
STARTUP_SCRIPT=$(cat <<EOF
#!/bin/bash
apt-get update && apt-get install -y mosh openssh-server
systemctl enable ssh && systemctl start ssh
EOF
)

# Create additional 150GB disk if it doesn't exist
if ! gcloud compute disks describe "$DATA_DISK_NAME" --zone="$ZONE" &>/dev/null; then
  echo "💽 Creating 150GB data disk $DATA_DISK_NAME"
  gcloud compute disks create "$DATA_DISK_NAME" \
    --size="$DATA_DISK_SIZE" \
    --zone="$ZONE" \
    --type=pd-standard
fi

# Create the VM
echo "🚀 Creating VM $VM_NAME"
gcloud compute instances create "$VM_NAME" \
  --zone="$ZONE" \
  --machine-type="$MACHINE_TYPE" \
  --image-family="$IMAGE_FAMILY" \
  --image-project="$IMAGE_PROJECT" \
  --boot-disk-size="$BOOT_DISK_SIZE" \
  --boot-disk-device-name="$VM_NAME" \
  --boot-disk-auto-delete \
  --tags="$FIREWALL_TAG,http-server,https-server" \
  --metadata=ssh-keys="$METADATA_ENTRY",startup-script="$STARTUP_SCRIPT" \
  --network-tier=STANDARD \
  --scopes=https://www.googleapis.com/auth/cloud-platform \
  --no-shielded-secure-boot \
  --no-shielded-integrity-monitoring \
  --no-shielded-vtpm \
  --disk=name="$DATA_DISK_NAME",device-name="data-disk",mode=rw,boot=no,auto-delete=yes

# Fetch the external IP
EXTERNAL_IP=$(gcloud compute instances describe "$VM_NAME" \
  --zone="$ZONE" \
  --format='get(networkInterfaces[0].accessConfigs[0].natIP)')

echo
echo "✅ VM '$VM_NAME' created successfully!"
echo "🌍 External IP: $EXTERNAL_IP"
echo
echo "🔐 SSH access:"
echo "ssh -i $KEY_PATH $USERNAME@$EXTERNAL_IP"
echo
echo "⚡ Mosh access:"
echo "mosh --ssh=\"ssh -i $KEY_PATH -p 22\" $USERNAME@$EXTERNAL_IP --port=$MOSH_PORTS"
echo

