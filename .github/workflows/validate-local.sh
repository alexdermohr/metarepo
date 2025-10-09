#!/bin/bash
set -euo pipefail

echo "---"
echo "Running local validation..."
echo "---"

# 1. Check if PyYAML is installed
if ! python -c "import yaml" &>/dev/null; then
    echo "WARNING: PyYAML not found. YAML validation will be skipped."
    echo "Please run: pip install pyyaml"
else
    echo "🔎 Validating YAML files..."
    # The original command is good, but adding a print statement for each file is better for UX.
    if ! git ls-files -z -- '*.yml' '*.yaml' | xargs -0 -r -I{} python -c "import yaml,sys; print('Checking {}'); sys.stdout.flush(); yaml.safe_load(open('{}'))"; then
        echo "❌ YAML validation failed."
        exit 1
    fi
    echo "✅ YAML validation successful."
fi

echo "---"

# 2. List templates
echo "🔎 Listing templates..."
find templates -type f | sort

echo "---"
echo "✅ Local validation finished."
