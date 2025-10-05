#!/bin/bash
# Initialize Compass vault on first run
# This script copies the vault template into the config directory
# and sets up Obsidian to auto-open it

VAULT_PATH="/config/Compass"
TEMPLATE_PATH="/vault-template"
OBSIDIAN_CONFIG="/config/.config/obsidian"

# Check if vault already exists
if [ -d "$VAULT_PATH" ]; then
    echo "Compass vault already exists at $VAULT_PATH"
else
    echo "Initializing Compass vault from template..."

    # Copy template to vault location
    cp -r "$TEMPLATE_PATH" "$VAULT_PATH"

    echo "Vault initialized at $VAULT_PATH"
fi

# Create Obsidian workspace config to auto-open the vault
# This creates the config that tells Obsidian which vault to open
mkdir -p "$OBSIDIAN_CONFIG"

# Create the obsidian.json file that tells Obsidian which vault to open
# Only create this if it doesn't exist yet (don't override user's choice after first run)
if [ ! -f "$OBSIDIAN_CONFIG/obsidian.json" ]; then
  cat > "$OBSIDIAN_CONFIG/obsidian.json" <<EOF
{"vaults":{"compass-main":{"path":"$VAULT_PATH","ts":$(date +%s)000,"open":true}}}
EOF
  echo "Obsidian configured to auto-open Compass vault"
else
  echo "Obsidian config already exists, skipping vault configuration"
fi
