#!/usr/bin/env bash

set -e

if [[ ! -x "$(command -v kubectl)" ]]; then
    echo "kubectl not found"
    exit 1
fi

if [[ ! -x "$(command -v helm)" ]]; then
    echo "helm not found"
    exit 1
fi

VERSION=1.9.0
REPO_ROOT=$(git rev-parse --show-toplevel)

echo "Installing Istio operator version ${VERSION}"
curl -sL https://istio.io/downloadIstio | ISTIO_VERSION=${VERSION} sh -

helm template "${REPO_ROOT}"/istio-${VERSION}/manifests/charts/istio-operator \
  --set hub=docker.io/istio \
  --set tag=${VERSION} \
  --set enableCRDTemplates=true \
  --set operatorNamespace=istio-operator \
  --set istioNamespace=istio-system  > "${REPO_ROOT}"/istio/operator/manifests.yaml

rm -rf "${REPO_ROOT}"/istio-${VERSION}

echo "Installing Prometheus"
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.9/samples/addons/prometheus.yaml

echo "Installing Kiali"
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.9/samples/addons/kiali.yaml

echo "Install Grafana"
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.9/samples/addons/grafana.yaml

echo "Installing Jaeger"
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.9/samples/addons/jaeger.yaml
