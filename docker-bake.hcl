variable "SUI_GIT_REVISION" {}

variable "PLATFORM" {}

variable "_PLATFORM_TAG" {
  default = regex_replace(PLATFORM, "/", "-")
}

variable "_REMOTE_CACHE_BUILDER_BASE" {
  default = "type=registry,ref=ghcr.io/shinamicorp/sui:cache-builder-base-${_PLATFORM_TAG}"
}

variable "_REMOTE_CACHE_RUNTIME_BASE" {
  default = "type=registry,ref=ghcr.io/shinamicorp/sui:cache-runtime-base-${_PLATFORM_TAG}"
}

variable "_REMOTE_CACHE_BINARIES" {
  default = "type=registry,ref=ghcr.io/shinamicorp/sui:cache-binaries-${SUI_GIT_REVISION}-${_PLATFORM_TAG}"
}

function "tag" {
  params = [target]
  result = "ghcr.io/shinamicorp/${target}:${SUI_GIT_REVISION}-${_PLATFORM_TAG}"
}

function "local_cache_dir" {
  params = [target]
  result = "./cache/${PLATFORM}/${target}"
}

target "_common" {
  platforms = [PLATFORM]
  args = {
    SUI_GIT_REVISION = SUI_GIT_REVISION
  }
  cache-from = [
    "type=local,src=${local_cache_dir("builder-base")}",
    "type=local,src=${local_cache_dir("runtime-base")}",
    "type=local,src=${local_cache_dir("binaries")}",
    _REMOTE_CACHE_BUILDER_BASE,
    _REMOTE_CACHE_RUNTIME_BASE,
    _REMOTE_CACHE_BINARIES,
  ]
}

# These cache-only targets are just to download/populate the caches.
target "cache-builder-base" {
  inherits = ["_common"]
  target   = "builder-base"
  output   = ["type=cacheonly"]
  cache-to = ["type=local,dest=${local_cache_dir("builder-base")}", _REMOTE_CACHE_BUILDER_BASE]
}

target "cache-runtime-base" {
  inherits = ["_common"]
  target   = "runtime-base"
  output   = ["type=cacheonly"]
  cache-to = ["type=local,dest=${local_cache_dir("runtime-base")}", _REMOTE_CACHE_RUNTIME_BASE]
}

target "cache-binaries" {
  inherits = ["_common"]
  target   = "binaries"
  output   = ["type=cacheonly"]
  cache-to = ["type=local,dest=${local_cache_dir("binaries")}", _REMOTE_CACHE_BINARIES]
}

# Single-platform targets.
# Requires creating multi-platform manifest list manually.
target "sui-node" {
  inherits = ["_common"]
  target   = "sui-node"
  tags     = [tag("sui-node")]
}

target "sui" {
  inherits = ["_common"]
  target   = "sui"
  tags     = [tag("sui")]
}

target "default" {
  inherits = ["sui-node"]
}
