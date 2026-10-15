#!/usr/bin/env bash

set -euo pipefail

CLUSTER_NAME="${CLUSTER_NAME:-week9-lab}"
CONTEXT_NAME="kind-${CLUSTER_NAME}"
NAMESPACE="${NAMESPACE:-devops-lab}"
DEPLOYMENT="${DEPLOYMENT:-week9-app}"
SERVICE="${SERVICE:-week9-app}"
LOCAL_PORT="${LOCAL_PORT:-18080}"

for required_command in docker kind kubectl curl; do
  if ! command -v "$required_command" >/dev/null 2>&1; then
    echo "Missing required command: $required_command" >&2
    exit 1
  fi
done

if ! kind get clusters | grep -Fxq "$CLUSTER_NAME"; then
  echo "kind cluster not found: $CLUSTER_NAME" >&2
  exit 1
fi

echo "Using Kubernetes context: $CONTEXT_NAME"
kubectl config use-context "$CONTEXT_NAME" >/dev/null

echo
echo "Cluster nodes:"
kubectl get nodes -o wide

echo
echo "Waiting for the application rollout..."
kubectl rollout status \
  "deployment/${DEPLOYMENT}" \
  --namespace "$NAMESPACE" \
  --timeout=120s

echo
echo "Deployment:"
kubectl get deployment "$DEPLOYMENT" \
  --namespace "$NAMESPACE" \
  --output wide

echo
echo "Pods:"
kubectl get pods \
  --namespace "$NAMESPACE" \
  --selector "app.kubernetes.io/name=${DEPLOYMENT}" \
  --output wide

echo
echo "Service:"
kubectl get service "$SERVICE" \
  --namespace "$NAMESPACE" \
  --output wide

echo
echo "EndpointSlices:"
kubectl get endpointslices \
  --namespace "$NAMESPACE" \
  --selector "kubernetes.io/service-name=${SERVICE}" \
  --output wide

PORT_FORWARD_LOG="$(mktemp -t week9-port-forward.XXXXXX)"
PORT_FORWARD_PID=""

cleanup() {
  if [[ -n "${PORT_FORWARD_PID:-}" ]]; then
    kill "$PORT_FORWARD_PID" >/dev/null 2>&1 || true
    wait "$PORT_FORWARD_PID" >/dev/null 2>&1 || true
  fi

  rm -f "$PORT_FORWARD_LOG"
}

trap cleanup EXIT

echo
echo "Starting temporary port-forward on port ${LOCAL_PORT}..."

kubectl port-forward \
  "service/${SERVICE}" \
  "${LOCAL_PORT}:80" \
  --namespace "$NAMESPACE" \
  >"$PORT_FORWARD_LOG" 2>&1 &

PORT_FORWARD_PID=$!

APPLICATION_READY=false

for _attempt in $(seq 1 20); do
  if curl \
    --fail \
    --silent \
    "http://127.0.0.1:${LOCAL_PORT}/health" \
    >/dev/null; then
    APPLICATION_READY=true
    break
  fi

  if ! kill -0 "$PORT_FORWARD_PID" >/dev/null 2>&1; then
    echo "Port-forward stopped unexpectedly." >&2
    cat "$PORT_FORWARD_LOG" >&2
    exit 1
  fi

  sleep 1
done

if [[ "$APPLICATION_READY" != "true" ]]; then
  echo "Application did not become reachable." >&2
  cat "$PORT_FORWARD_LOG" >&2
  exit 1
fi

echo
echo "Application response:"

curl \
  --fail \
  --silent \
  --show-error \
  "http://127.0.0.1:${LOCAL_PORT}/"

echo
echo
echo "Health response:"

curl \
  --fail \
  --silent \
  --show-error \
  "http://127.0.0.1:${LOCAL_PORT}/health"

echo
echo
echo "Recent application logs:"

kubectl logs \
  --namespace "$NAMESPACE" \
  --selector "app.kubernetes.io/name=${DEPLOYMENT}" \
  --all-containers=true \
  --prefix \
  --tail=20

echo
echo "Week 9 Kubernetes verification passed."
