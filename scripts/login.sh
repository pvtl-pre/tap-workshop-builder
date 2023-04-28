#!/bin/bash
set -e -o pipefail
shopt -s nocasematch

# Azure Login
az login --service-principal -u "$AZURE_SERVICE_PRINCIPAL_CLIENT_ID" -p "$AZURE_SERVICE_PRINCIPAL_CLIENT_SECRET" --tenant "$AZURE_TENANT_ID"

# pivnet
pivnet login --api-token="$PIVNET_REFRESH_TOKEN"
