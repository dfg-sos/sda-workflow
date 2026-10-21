#!/bin/bash
# Builds the sda-no-db and sda images and optionally pushes them to the registry.
# Usage: ./update.sh [--push] [version]
#   version defaults to the git tag pointing at HEAD
#   REGISTRY can be overridden via environment variable (default: ghcr.io/dfg-sos)
set -euo pipefail
cd "$(dirname "$0")"

PUSH=false
if [[ "${1:-}" == "--push" ]]; then
    PUSH=true
    shift
fi
VERSION=${1:-$(git describe --tags --exact-match 2>/dev/null || true)}
REGISTRY=${REGISTRY:-ghcr.io/dfg-sos}
TARGETS=(sda-no-db sda)

if [[ -z "${VERSION}" ]]; then
    echo "No version given and HEAD is not tagged. Usage: $0 [--push] [version]" >&2
    exit 1
fi
# the Dockerfile copies the working tree, so uncommitted changes would end up in the image
if [[ -n "$(git status --porcelain)" ]]; then
    echo "Working tree is not clean, commit or stash your changes first." >&2
    exit 1
fi

# --provenance=false pushes a plain image manifest instead of an index,
# otherwise ghcr ignores the source label and does not link the package to the repository
BUILD_ARGS=(--provenance=false --build-arg VERSION="${VERSION}" --build-arg REVISION="$(git rev-parse HEAD)")

for TARGET in "${TARGETS[@]}"; do
    docker build "${BUILD_ARGS[@]}" --target "${TARGET}" \
        -t "${REGISTRY}/${TARGET}:${VERSION}" -t "${REGISTRY}/${TARGET}:latest" .
done

if [[ "${PUSH}" == true ]]; then
    docker login "${REGISTRY%%/*}"
    for TARGET in "${TARGETS[@]}"; do
        docker push "${REGISTRY}/${TARGET}:${VERSION}"
        docker push "${REGISTRY}/${TARGET}:latest"
    done
fi
