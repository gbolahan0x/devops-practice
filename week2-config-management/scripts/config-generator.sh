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
mkdir -p "GENERATED_DIR" "$LOGS_DIR"

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

# Main function
generate_config() {
    local environment=$1
    
    echo -e "${YELLOW}Generating config for environment: $environment${NC}"
    
    # 1. Validate environment file exists
    local env_file="$ENVIRONMENTS_DIR/$environment.env"
    if [ ! -f "$env_file" ]; then
        error_exit "Environment file not found: $env_file"
    fi
    
    echo -e "${GREEN}✓ Found environment file: $env_file${NC}"
    
    # 2. Load environment variables
    export ENVIRONMENT="$environment"
    # shellcheck source=/dev/null
    source "$env_file"
    
    log_change "Loading environment: $environment"
    
    # 3. Generate configs from templates
    echo -e "\n${YELLOW}Generating from templates...${NC}"
    
    # Find all template files
    for template in "$TEMPLATES_DIR"/*.j2; do
        if [ ! -f "$template" ]; then
            echo "No templates found"
            continue
        fi
        
        local template_name=$(basename "$template" .j2)
        local output_file="$GENERATED_DIR/${template_name}-${environment}.yaml"
        
        echo -n "  Processing $template_name... "
        
        # Use sed to replace all {{ VAR }} with values
        sed \
            -e "s|{{ ENVIRONMENT }}|$ENVIRONMENT|g" \
            -e "s|{{ DATABASE_HOST }}|$DATABASE_HOST|g" \
            -e "s|{{ DATABASE_PORT }}|$DATABASE_PORT|g" \
            -e "s|{{ DATABASE_USER }}|$DATABASE_USER|g" \
            -e "s|{{ DATABASE_PASSWORD }}|$DATABASE_PASSWORD|g" \
            -e "s|{{ DATABASE_NAME }}|$DATABASE_NAME|g" \
            -e "s|{{ API_HOST }}|$API_HOST|g" \
            -e "s|{{ API_PORT }}|$API_PORT|g" \
            -e "s|{{ API_ENDPOINT }}|$API_ENDPOINT|g" \
            -e "s|{{ LOG_LEVEL }}|$LOG_LEVEL|g" \
            -e "s|{{ LOG_FORMAT }}|$LOG_FORMAT|g" \
            -e "s|{{ DEBUG_MODE }}|$DEBUG_MODE|g" \
            -e "s|{{ ENABLE_CACHING }}|$ENABLE_CACHING|g" \
            -e "s|{{ ENABLE_PROFILING }}|$ENABLE_PROFILING|g" \
            -e "s|{{ SSL_ENABLED }}|$SSL_ENABLED|g" \
            -e "s|{{ CORS_ALLOWED_ORIGINS }}|$CORS_ALLOWED_ORIGINS|g" \
            -e "s|{{ DATABASE_TIMEOUT }}|$DATABASE_TIMEOUT|g" \
            -e "s|{{ API_TIMEOUT }}|$API_TIMEOUT|g" \
            "$template" > "$output_file"
        
        echo -e "${GREEN}✓${NC}"
        log_change "Generated: $output_file"
    done
    
    # 4. Summary
    echo -e "\n${GREEN}Configuration generation complete!${NC}"
    echo -e "\nGenerated files:"
    ls -lh "$GENERATED_DIR"/*"$environment"* 2>/dev/null || echo "  (none found)"
    
    log_change "Configuration generation completed successfully for $environment"
}

# Usage check
if [ $# -eq 0 ]; then
    echo "Usage: $0 [dev|staging|prod]"
    echo ""
    echo "Available environments:"
    ls -1 "$ENVIRONMENTS_DIR"/*.env 2>/dev/null | xargs -n1 basename | sed 's/.env//'
    exit 1
fi

# Execute
generate_config "$1"