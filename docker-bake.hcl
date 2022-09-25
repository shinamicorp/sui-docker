variable "SUI_RELEASE" {}

variable "PLATFORM" {}

function "tags" {
  params = [target]
  result = ["ghcr.io/shinamicorp/${target}:${SUI_RELEASE}-${regex_replace(PLATFORM, "/", "-")}"]
}

function "tags_multi_platform" {
  params = [target]
  result = ["ghcr.io/shinamicorp/${target}:${SUI_RELEASE}"]
}

function "cache" {
  params = [target]
  result = "type=registry,ref=ghcr.io/shinamicorp/${target}:cache-${regex_replace(PLATFORM, "/", "-")}"
}

function "cache_multi_platform" {
  params = [target]
  result = "type=registry,ref=ghcr.io/shinamicorp/${target}:cache"
}

# Single-platform targets.
# Requires creating multi-platform manifest list manually.
target "sui-node" {
  platforms = [PLATFORM]
  target = "sui-node"
  output = ["type=image"]
  args = {
    SUI_RELEASE = SUI_RELEASE
  }
  tags = tags("sui-node")
  cache-from = [cache("sui-node")] # always merged with children's cache-from
  cache-to = ["${cache("sui-node")},mode=max"]
}

target "sui" {
  inherits = ["sui-node"]
  target = "sui"
  tags = tags("sui")
  # Sharing the same cache with sui-node
}

target "default" {
  inherits = ["sui-node"]
}

# Multi-platform targets.
# They don't really work because cross-compilation of Sui keeps hitting memory limit.
target "sui-node-multi-platform" {
  platforms = ["linux/amd64", "linux/arm64"]
  target = "sui-node"
  output = ["type=image"]
  args = {
    SUI_RELEASE = SUI_RELEASE
  }
  tags = tags_multi_platform("sui-node")
  cache-from = [cache_multi_platform("sui-node")] # always merged with children's cache-from
  cache-to = ["${cache_multi_platform("sui-node")},mode=max"]
}

target "sui-multi-platform" {
  inherits = ["sui-node-multi-platform"]
  target = "sui"
  tags = tags_multi_platform("sui")
  # Sharing the same cache with sui-node
}
