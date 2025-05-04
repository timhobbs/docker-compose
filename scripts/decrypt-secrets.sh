#!/bin/bash
# Decrypt all matching encrypted files from binary with sops

set -e

# Patterns to look for encrypted files
ENCRYPTED_PATTERNS=("*.enc")

echo "🔓 Decrypting secret files..."

for pattern in "${ENCRYPTED_PATTERNS[@]}"; do
    while IFS= read -r -d '' file; do
        output_file="${file%.enc}"
        echo "Decrypting: $file -> $output_file"

        # Explicitly decrypt as binary (ignore .sops.yaml)
        sops --input-type binary --output-type binary -d "$file" > "$output_file"

        echo "✅ Decrypted: $output_file"
    done < <(find . -type f -name "$pattern" -print0)
done

echo "✅ All encrypted files decrypted."
