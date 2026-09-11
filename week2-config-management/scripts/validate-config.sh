#####################################
# Configuration Validator 
# Purpose: Validate generated configs
# Usage: ./validate-config.sh
#####################################


set -euo pipefail

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

error_exit() {
	echo -e "${RED}✗ VALIDATION FAILED: $1${NC}" >&2
	exit 1
}

validate_config() {
	local config_file=$1

	if [ ! -f "$config_file" ]; then
		error_exit "Config file not found: $config_file"
	fi

	echo -e "${YELLOW}Validating: $config_files${NC}\n"

	local errors=0

	# Check 1: File is readable
	if [ ! -r "$config_file" ]; then
		echo -e "${RED}✗ File is not readable${NC}"
		((errors++))
	else
		echo -e "${GREEN}✓ File is readable${NC}"
	fi

	# Check 2: No unresolved variables
	if grep -q "{{ .* }}" "$config_file"; then
		echo -e "${RED}✗ Unresolved variables found:${NC}"
		grep "{{ .* }}" "$config_file" | sed 's/ˆ/ /'
		((errors++))
	else
		echo -e "${GREEN}✓ No unresolved variables${NC}"
	fi

	#Check 3: Required fields present
	local required_fields=("database:" "api:" "logging:")
	for field in "${required_fields[@]}"; do
		if grep -q "$field" "$config_file"; then
			echo -e "${GREEN}✓ Found required field: $field${NC}"
		else
			echo -e "${RED}✗ Missing required field: $field${NC}"
			((errors++))
		fi
	done

	# Check 4: Valid YAML Structure
	if command -v yamllint &> /dev/null; then
		if yamllint -c relaxed "$config_file" > /dev/null 2>&1; then
			echo -e "${GREEN}✓ Valid YAML structure${NC}"
        else
            echo -e "${RED}✗ Invalid YAML structure${NC}"
            yamllint -c relaxed "$config_file" | head -5
            ((errors++))
        fi
    else
    	echo -e "${YELLOW}⚠ yamllint not installed (skipping YAML validation)${NC}"
    fi

    #Check 5: No obvious errors
    # Check 5: No obvious errors
    if grep -q "password.*dev\|password.*staging" "$config_file" 2>/dev/null; then
        echo -e "${YELLOW}⚠ WARNING: Dev/staging passwords in config${NC}"
    fi
    
    # Summary
    echo ""
    if [ $errors -eq 0 ]; then
        echo -e "${GREEN}✓ VALIDATION PASSED${NC}"
        return 0
    else
        echo -e "${RED}✗ VALIDATION FAILED ($errors errors)${NC}"
        return 1
    fi
}

# Usage check
if [ $# -eq 0 ]; then
    echo "Usage: $0 [config_file]"
    exit 1
fi

# Execute
validate_config "$1"

}