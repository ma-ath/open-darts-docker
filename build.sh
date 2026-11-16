#!/usr/bin/env bash
set -Eeuo pipefail

WORKSPACE="/workspaces/open-darts-docker"
SUBMODULES="${WORKSPACE}/submodules"

OPEN_DARTS="${SUBMODULES}/open-darts"
DARTS_MODELS="${SUBMODULES}/darts-models"
DARTS_FLASH="${SUBMODULES}/darts-flash"
AMGX="${OPEN_DARTS}/thirdparty/AMGX"

OPEN_DARTS_PATCH="${WORKSPACE}/patches/open-darts.patch"
BUILD_TYPE="Release"
BUILD_JOBS="${BUILD_JOBS:-$(nproc)}"

# Initialize git
echo "Initializing Git submodules..."
git -C "${WORKSPACE}" submodule update --init --recursive

# Patch Open-DARTS
echo "Applying open-darts patch..."
if git -C "${OPEN_DARTS}" apply --check "${OPEN_DARTS_PATCH}"; then
    git -C "${OPEN_DARTS}" apply "${OPEN_DARTS_PATCH}"
    echo "Patch applied successfully."
elif git -C "${OPEN_DARTS}" apply --reverse --check "${OPEN_DARTS_PATCH}"; then
    echo "Patch already applied. Skipping."
fi

# Build and Install AMGX
echo "Building AMGX"
cmake -S "${AMGX}" -B "${AMGX}/build" \
    -DCMAKE_BUILD_TYPE="${BUILD_TYPE}"
cmake --build "${AMGX}/build" --parallel "${BUILD_JOBS}"
sudo cmake --install "${AMGX}/build"

# Build open-DARTS
cd "${OPEN_DARTS}"
source "helper_scripts/build_install_darts_gpu.sh" | true

# Build darts-flash
cd "${DARTS_FLASH}"
source "${DARTS_FLASH}/helper_scripts/build.sh" | true

# Install Python things
cd "${WORKSPACE}"
rm -rf .venv
uv sync