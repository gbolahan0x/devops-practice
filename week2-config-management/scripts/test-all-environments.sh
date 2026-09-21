#!/bin/bash

##############################################
# Test All Environments
# Purpose: Test configs for all environments
# Usage: ./test-all-environments.sh
##############################################

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPT_DIR="$PROJECT_DIR/scripts"
GENERATED_DIR="$PROJECT_DIR/generated"
ENVIRONMENTS=("dev" "staging" "prod")

echo "========================================"
echo "Testing All Environments"
echo "========================================"
echo ""

errors=0

for env in "${ENVIRONMENTS[@]}"; do
	echo "Testing: $env"
	echo "---"

	if "$SCRIPT_DIR/config-generator.sh" "$env" && "$SCRIPT_DIR/validate-config.sh" "$GENERATED_DIR/app-config-${env}.yaml"; then
		echo "✓ Configuration generated and validated"
	else
		echo "✗ Configuration generation or validation failed"
		((errors += 1))
	fi

	echo ""
done

echo "============================================"
if [ $errors -eq 0 ]; then
	echo "✓ ALL TESTS PASSED"
	exit 0
else
	echo "✗ TESTS FAILED ($errors errors)"
	exit 1
fi
