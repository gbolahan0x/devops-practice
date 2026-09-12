#!/bin/bash

######################################
# Deploy with config
# Purpose: Deploy app with environment config
# Usage: ./deploy-with-config.sh [environment]
######################################

set -euo pipefail

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_deployment() {
	echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$DEPLOY_LOG"
}

error_exit(){
	echo -e "${RED}ERROR: $1${NC}" >&2
	log_deployment "ERROR: $1"
	exit 1
}

deploy(){
	local environment=$1

	echo -e "${YELLOW}=== Deploying to $environment ===${NC}\n"

	#Step 1: Generate configs
	echo -e "${YELLOW}Step 1: Generating configuration...${NC}"
	if ! "$SCRIPT_DIR/config-generator.sh" "$environment"; then
		error_exit "Failed to generate configuration"
	fi

	#Step 2: Validate configs
	echo -e "\n${YELLOW}Step 2: Validatin configuration...${NC}"
	local config_file="$GENERATED_DIR/app-config-${environment}.yaml"

	if [ ! -f "$config_file" ]; then
		error_exit "Generated config not found: $config_file"
	fi

	if ! "$SCRIPT_DIR/validate-config.sh" "$config_file"; then
		error_exit "Configuration validation failed"
	fi

	#Step 3: Deploy (simulate)
	echo -e "\n${YELLOW}Step 3: Deploying application...${NC}"

	#Simulate
	echo "  - Stopping Application..."
	sleep 1
	echo "  - Copying Configuration..."
	#cp "$config_file" /etc/myapp/config.yaml #Real deployment
	echo "  - Starting application..."
	sleep 1
	echo -e "   ${GREEN}✓ Apllication running${NC}"

	#Step 4: verify
	echo -e "\n${YELLOW}Step 4: Verifyng deployment...${NC}"
	echo -e " ${GREEN}✓ All health checks passed${NC}"

	#Step 5: Log
	log_deployment "Deployed to $environment -SUCCESS"

	echo -e "\n${GREEN}=== deployment Complete ===${NC}"
	echo ""
	echo "Configuration file: $config_file"
	echo "Deployment log: $DEPLOY_LOG"
}

#Usage
if [ $# -eq 0 ]; then
	echo "Usage: $0 [dev|staging|prod]"
	exit 1
fi

deploy "$1"