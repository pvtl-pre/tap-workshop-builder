#!/bin/bash
set -e -o pipefail
shopt -s nocasematch

# Clone tap-made-simple
git clone https://github.com/pvtl-pre/tap-made-simple.git
cd tap-made-simple

# Create local params.yaml
export PARAMS_YAML="local-config/params.yaml"
mkdir -p local-config
cp REDACTED-params.yaml $PARAMS_YAML

# Update local params.yaml
yq e -i '.tanzu_registry.username = env(TANZU_REGISTRY_USERNAME)' "$PARAMS_YAML"
yq e -i '.tanzu_registry.password = env(TANZU_REGISTRY_PASSWORD)' "$PARAMS_YAML"

yq e -i '.azure.resource_group = env(USER_RESOURCE_GROUP)' "$PARAMS_YAML"

yq e -i '.azure.acr.name = "tapmadesimple" + env(USERNAME)' "$PARAMS_YAML"

yq e -i '.azure.dns.auto_configure = true' "$PARAMS_YAML"
yq e -i '.azure.dns.dns_zone_name = env(DNS_ZONE_NAME)' "$PARAMS_YAML"
yq e -i '.azure.dns.resource_group = env(DNS_ZONE_RESOURCE_GROUP)' "$PARAMS_YAML"

yq e -i '.clusters.view_cluster.ingress_domain = "tap." + env(USERNAME) + "." + env(DNS_ZONE_NAME)' "$PARAMS_YAML"
yq e -i '.clusters.view_cluster.learning_center_ingress_domain = "learningcenter." + env(USERNAME) + "." + env(DNS_ZONE_NAME)' "$PARAMS_YAML"
yq e -i '.clusters.iterate_cluster.ingress_domain = "iterate." + env(USERNAME) + "." + env(DNS_ZONE_NAME)' "$PARAMS_YAML"
yq e -i 'del(.clusters.run_clusters[0])' "$PARAMS_YAML"
yq e -i '.clusters.run_clusters[0].ingress_domain = "prod." + env(USERNAME) + "." + env(DNS_ZONE_NAME)' "$PARAMS_YAML"

# Build Azure infrastructure
./scripts/01-prep-azure-objects.sh
./scripts/02-deploy-azure-container-registry.sh
./scripts/03-deploy-azure-k8s-clusters.sh
