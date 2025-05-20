echo "hello world"

#!/bin/bash

# Usage: ./copy_encrypt.sh /path/to/source /path/to/destination [encryption_password]

SRC_DIR="$1"
DEST_DIR="$2"
PASSWORD="$3"
CIPHER="aes-256-cbc"

# Check args
if [[ -z "$SRC_DIR" || -z "$DEST_DIR" ]]; then
    echo "Usage: $0 <source_dir> <destination_dir> [password]"
    exit 1
fi

# Ask for password if not provided
if [[ -z "$PASSWORD" ]]; then
    read -s -p "Enter encryption password: " PASSWORD
    echo
fi

# Create destination dir if needed
mkdir -p "$DEST_DIR"

# Copy and encrypt files
for FILE in "$SRC_DIR"/*; do
    if [[ -f "$FILE" ]]; then
        BASENAME=$(basename "$FILE")
        DEST_FILE="$DEST_DIR/$BASENAME.enc"
        echo "Encrypting $BASENAME → $DEST_FILE"
        openssl enc -${CIPHER} -salt -in "$FILE" -out "$DEST_FILE" -pass pass:"$PASSWORD"
    fi
done

echo "✅ Done encrypting files to $DEST_DIR"
