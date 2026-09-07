FROM mcr.microsoft.com/devcontainers/base:ubuntu

ARG NPM_CONFIG_REGISTRY
ARG PIP_INDEX_URL
ARG RestoreSources

RUN apt-get update \
    && apt-get install -y --no-install-recommends wl-clipboard \
    && rm -rf /var/lib/apt/lists/*

ENV NPM_CONFIG_REGISTRY="${NPM_CONFIG_REGISTRY:-https://registry.npmjs.org/}" \
    PIP_INDEX_URL="${PIP_INDEX_URL:-https://pypi.org/simple/}" \
    RestoreSources="${RestoreSources:-https://api.nuget.org/v3/index.json}"
