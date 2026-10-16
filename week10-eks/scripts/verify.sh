#!/usr/bin/env bash

set -euo pipefail

cluster_name="${EKS_CLUSTER_NAME:-week10-dev-cluster}"
aws_region="${AWS_REGION:-eu-west-1}"
namespace="${K8S_NAMESPACE:-devops-lab}"
deployment_name="${K8S_DEPLOYMENT:-week10-app}"
service_name="${K8S_SERVICE:-week10-app}"
local_port="${LOCAL_PORT:-18080}"

printf 'Checking AWS identity...\n'
aws sts get-caller-identity --output table

printf '\nChecking EKS cluster...\n'
aws eks describe-cluster \
  --name "$cluster_name" \
  --region "$aws_region" \
  --query 'cluster.{Name:name,Status:status,Version:version,EndpointAccess:resourcesVpcConfig.endpointPublicAccess}' \
  --output table

printf '\nChecking Kubernetes nodes...\n'
kubectl get nodes --output wide

printf '\nWaiting for the application rollout...\n'
kubectl rollout status \
  "deployment/$deployment_name" \
  --namespace "$namespace" \
  --timeout=180s

printf '\nChecking application resources...\n'
kubectl get deployment,pods,service \
  --namespace "$namespace" \
  --output wide

printf '\nChecking Service endpoints...\n'
kubectl get endpointslice \
  --namespace "$namespace" \
  --selector "kubernetes.io/service-name=$service_name"

port_forward_log="$(mktemp -t week10-port-forward.XXXXXX)"

kubectl port-forward \
  --namespace "$namespace" \
  "service/$service_name" \
  "$local_port:80" >"$port_forward_log" 2>&1 &

port_forward_pid=$!

cleanup() {
  kill "$port_forward_pid" 2>/dev/null || true
  wait "$port_forward_pid" 2>/dev/null || true
}

trap cleanup EXIT

for attempt in {1..20}; do
  if curl --fail --silent "http://127.0.0.1:$local_port/health" >/dev/null; then
    break
  fi

  if ! kill -0 "$port_forward_pid" 2>/dev/null; then
    printf 'Port-forward stopped unexpectedly:\n' >&2
    sed -n '1,120p' "$port_forward_log" >&2
    exit 1
  fi

  if [ "$attempt" -eq 20 ]; then
    printf 'Application did not become reachable through port-forward.\n' >&2
    sed -n '1,120p' "$port_forward_log" >&2
    exit 1
  fi

  sleep 1
done

printf '\nApplication response:\n'
curl --fail --silent --show-error "http://127.0.0.1:$local_port/"

printf '\n\nHealth response:\n'
curl --fail --silent --show-error "http://127.0.0.1:$local_port/health"

printf '\n\nVerification passed.\n'
