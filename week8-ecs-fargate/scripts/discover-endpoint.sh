#!/usr/bin/env bash

set -euo pipefail

AWS_REGION="${AWS_REGION:-eu-west-1}"
CLUSTER_NAME="${1:-week8-dev-cluster}"
SERVICE_NAME="${2:-week8-dev-service}"

echo "Finding a running task..."

TASK_ARN="$(
  aws ecs list-tasks \
    --cluster "$CLUSTER_NAME" \
    --service-name "$SERVICE_NAME" \
    --desired-status RUNNING \
    --region "$AWS_REGION" \
    --query 'taskArns[0]' \
    --output text
)"

if [[ -z "$TASK_ARN" || "$TASK_ARN" == "None" ]]; then
  echo "No running ECS task was found." >&2
  exit 1
fi

ENI_ID="$(
  aws ecs describe-tasks \
    --cluster "$CLUSTER_NAME" \
    --tasks "$TASK_ARN" \
    --region "$AWS_REGION" \
    --query 'tasks[0].attachments[0].details[?name==`networkInterfaceId`].value' \
    --output text
)"

if [[ -z "$ENI_ID" || "$ENI_ID" == "None" ]]; then
  echo "The task network interface could not be found." >&2
  exit 1
fi

PUBLIC_IP="$(
  aws ec2 describe-network-interfaces \
    --network-interface-ids "$ENI_ID" \
    --region "$AWS_REGION" \
    --query 'NetworkInterfaces[0].Association.PublicIp' \
    --output text
)"

if [[ -z "$PUBLIC_IP" || "$PUBLIC_IP" == "None" ]]; then
  echo "The task does not currently have a public IP." >&2
  exit 1
fi

echo
echo "Task ARN: $TASK_ARN"
echo "Network interface: $ENI_ID"
echo "Public IP: $PUBLIC_IP"
echo "Application URL: http://${PUBLIC_IP}:3000"
echo "Health URL: http://${PUBLIC_IP}:3000/health"
echo
echo "Testing the application..."

curl \
  --fail \
  --silent \
  --show-error \
  "http://${PUBLIC_IP}:3000/"

echo

curl \
  --fail \
  --silent \
  --show-error \
  "http://${PUBLIC_IP}:3000/health"

echo
