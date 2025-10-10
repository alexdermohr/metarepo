#!/bin/bash
set -euo pipefail

# Check for yq - a lightweight and portable command-line YAML processor.
# https://github.com/mikefarah/yq
if ! command -v yq &> /dev/null; then
    echo "yq could not be found. Please install it."
    echo "See: https://github.com/mikefarah/yq#install"
    exit 1
fi

# Get all tracked .yml and .yaml files
YAML_FILES=$(git ls-files -- '*.yml' '*.yaml')

if [ -z "$YAML_FILES" ]; then
    echo "No YAML files to validate."
    exit 0
fi

# Validate each YAML file
for file in $YAML_FILES; do
    echo "Validating $file..."
    if ! yq eval 'length > 0' "$file" >/dev/null; then
        echo "Validation failed for $file"
        exit 1
    fi
done

echo "All YAML files are valid."

echo "---"

# 2. List templates
echo "🔎 Listing templates..."
find templates -type f | sort

echo "---"
echo "✅ Local validation finished."