#!/usr/bin/env bash
set -e

if [[ ! -x "$(command -v istioctl)" ]]; then
    echo "istioctl not found"
    exit 1
fi

istioctl dashboard kiali &
istioctl dashboard jaeger &
istioctl dashboard grafana &
