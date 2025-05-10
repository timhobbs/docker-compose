#!/bin/bash
# Encrypt all matching secret files as binary with sops

set -e

# Patterns to look for (edit as needed)
FILE_PATTERNS=("*.env" "cf-token")

# Recipient's age public key (replace with your actual key)
AGE_RECIPIENT="age1s3rfmumcn87ph9327zgsaqc2lgu3jjwfmtxdrl888h8872cpqg0qs2sx8w"

echo "🔐 Encrypting secret files..."

for pattern in "${FILE_PATTERNS[@]}"; do
    while IFS= read -r -d '' file; do
        if [[ $file != *.enc ]]; then
            echo "Encrypting: $file"
            tmp_file=$(mktemp)
            cp "$file" "$tmp_file"

            # Explicitly encrypt as binary (ignore .sops.yaml)
            sops --input-type binary --output-type binary --age "$AGE_RECIPIENT" -e "$tmp_file" > "${file}.enc"

            rm "$tmp_file"
            echo "✅ Encrypted to: ${file}.enc"
        fi
    done < <(find . -type f -name "$pattern" -print0)
done

echo "✅ All matching files encrypted."
