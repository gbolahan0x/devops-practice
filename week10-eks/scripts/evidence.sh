#!/usr/bin/env bash

set -euo pipefail

cluster_name="${EKS_CLUSTER_NAME:-week10-dev-cluster}"
node_group_name="${EKS_NODE_GROUP_NAME:-week10-dev-workers}"
aws_region="${AWS_REGION:-eu-west-1}"
namespace="${K8S_NAMESPACE:-devops-lab}"

printf 'AWS identity\n'
aws sts get-caller-identity --output table

printf '\nEKS cluster\n'
aws eks describe-cluster \
  --name "$cluster_name" \
  --region "$aws_region" \
  --query 'cluster.{Name:name,Status:status,Version:version,PrivateEndpoint:resourcesVpcConfig.endpointPrivateAccess,PublicEndpoint:resourcesVpcConfig.endpointPublicAccess,PublicCIDRs:resourcesVpcConfig.publicAccessCidrs}' \
  --output table

printf '\nManaged node group\n'
aws eks describe-nodegroup \
  --cluster-name "$cluster_name" \
  --nodegroup-name "$node_group_name" \
  --region "$aws_region" \
  --query 'nodegroup.{Name:nodegroupName,Status:status,Capacity:capacityType,InstanceTypes:instanceTypes,Desired:scalingConfig.desiredSize}' \
  --output table

printf '\nEKS access entries\n'
aws eks list-access-entries \
  --cluster-name "$cluster_name" \
  --region "$aws_region" \
  --output table

printf '\nKubernetes nodes\n'
kubectl get nodes --output wide

printf '\nApplication resources\n'
kubectl get deployment,pods,service \
  --namespace "$namespace" \
  --output wide

printf '\nDeployed image\n'
kubectl get deployment week10-app \
  --namespace "$namespace" \
  --output jsonpath='{.spec.template.spec.containers[0].image}{"\n"}'
