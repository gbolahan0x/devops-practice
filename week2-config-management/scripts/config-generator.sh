#!/bin/bash

######################################################
# Configuration Generator
# Purpose: Generate configs from templates
# Usage: ./config-generator.sh [environment]

######################################################

set -euo pipefail

# Configuration
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEMPLATES_DIR="$PROJECT_DIR/templates"
ENVIRONMENTS_DIR="$PROJECT_DIR/environments"
GENERATED_DIR="$PROJECT_DIR/generated"
LOGS_DIR="$PROJECT_DIR/logs"
LOG_FILE="$PROJECT_DIR/config-changes.log"

# Create directories if they don't exist
mkdir -p "$GENERATED_DIR" "$LOGS_DIR"
# Color output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Logging function
log_change() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# Error handling
error_exit() {
    echo -e "${RED}ERROR: $1${NC}" >&2
    log_change "ERROR: $1"
    exit 1
}

validate_environment() {
    case "$1" in
        dev|staging|prod) ;;
        *) error_exit "Unsupported environment: $1. Use dev, staging, or prod." ;;
    esac
}

load_environment() {
    local env_file=$1
    local line key value line_number=0

    while IFS= read -r line || [ -n "$line" ]; do
        ((line_number += 1))
        line=${line%$'\r'}

        # Allow blank lines, comments, and the optional bash shebang.
        if [[ -z ${line//[[:space:]]/} || $line =~ ^[[:space:]]*# ]]; then
            continue
        fi

        if [[ ! $line =~ ^([A-Z][A-Z0-9_]*)=(.*)$ ]]; then
            error_exit "Invalid environment entry in $env_file at line $line_number"
        fi

        key=${BASH_REMATCH[1]}
        value=${BASH_REMATCH[2]}
        printf -v "$key" '%s' "$value"
    done < "$env_file"
}

escape_sed_replacement() {
    local value=$1
    value=${value//\\/\\\\}
    value=${value//&/\\&}
    value=${value//|/\\|}
    printf '%s' "$value"
}

require_variables() {
    local variable
    local required_variables=(
        DATABASE_HOST DATABASE_PORT DATABASE_USER DATABASE_PASSWORD DATABASE_NAME
        API_HOST API_PORT API_ENDPOINT LOG_LEVEL LOG_FORMAT DEBUG_MODE
        ENABLE_CACHING ENABLE_PROFILING SSL_ENABLED CORS_ALLOWED_ORIGINS
        DATABASE_TIMEOUT API_TIMEOUT
    )

    for variable in "${required_variables[@]}"; do
        if [[ -z ${!variable:-} ]]; then
            error_exit "Required variable is missing or empty: $variable"
        fi
    done
}

# Main function
generate_config() {
    local environment=$1
    local template template_name stem extension output_file variable value
    local templates=()
    local generated_files=()
    local sed_args=()

    validate_environment "$environment"
    
    echo -e "${YELLOW}Generating config for environment: $environment${NC}"
    
    # 1. Validate environment file exists
    local env_file="$ENVIRONMENTS_DIR/$environment.env"
    if [ ! -f "$env_file" ]; then
        error_exit "Environment file not found: $env_file"
    fi
    
    echo -e "${GREEN}✓ Found environment file: $env_file${NC}"
    
    # 2. Load simple KEY=value entries without executing the environment file.
    ENVIRONMENT="$environment"
    load_environment "$env_file"
    require_variables
    
    log_change "Loading environment: $environment"
    
    # 3. Generate configs from templates
    echo -e "\n${YELLOW}Generating from templates...${NC}"
    
    templates=("$TEMPLATES_DIR"/*.j2)
    if [ ! -e "${templates[0]}" ]; then
        error_exit "No templates found in $TEMPLATES_DIR"
    fi

    for template in "${templates[@]}"; do
        template_name=$(basename "$template" .j2)
        if [[ "$template_name" == *.* ]]; then
            stem=${template_name%.*}
            extension=${template_name##*.}
            output_file="$GENERATED_DIR/${stem}-${environment}.${extension}"
        else
            output_file="$GENERATED_DIR/${template_name}-${environment}"
        fi
        
        echo -n "  Processing $template_name... "
        
        # Escape values before using them in a sed replacement expression.
        sed_args=()
        for variable in ENVIRONMENT DATABASE_HOST DATABASE_PORT DATABASE_USER DATABASE_PASSWORD DATABASE_NAME API_HOST API_PORT API_ENDPOINT LOG_LEVEL LOG_FORMAT DEBUG_MODE ENABLE_CACHING ENABLE_PROFILING SSL_ENABLED CORS_ALLOWED_ORIGINS DATABASE_TIMEOUT API_TIMEOUT; do
            value=$(escape_sed_replacement "${!variable}")
            sed_args+=( -e "s|{{ $variable }}|$value|g" )
        done

        sed "${sed_args[@]}" "$template" > "$output_file"

        echo -e "${GREEN}✓${NC}"
        generated_files+=("$output_file")
        log_change "Generated: $output_file"
    done
    
    # 4. Summary
    echo -e "\n${GREEN}Configuration generation complete!${NC}"
    echo -e "\nGenerated files:"
    ls -lh "${generated_files[@]}"
    
    log_change "Configuration generation completed successfully for $environment"
}

# Usage check
if [ $# -ne 1 ]; then
    echo "Usage: $0 [dev|staging|prod]"
    echo ""
    echo "Available environments:"
    ls -1 "$ENVIRONMENTS_DIR"/*.env 2>/dev/null | xargs -n1 basename | sed 's/.env//'
    exit 1
fi

# Execute
generate_config "$1"
