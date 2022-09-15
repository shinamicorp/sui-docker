variable "SUI_RELEASE" {
  default = "devnet-0.9.0"
}

target "sui-node" {
  # In theory this should make it a single command to bake both platforms
  # ... except it doesn't work for this image. Cross compilation keeps hitting memory limit.
  # In practice, we ended up building these individually on their corresponding host, and crafting
  # multi-platform manifests by hand.
  platforms = ["linux/amd64", "linux/arm64"] 
  tags = ["ghcr.io/shinamicorp/sui-node:${SUI_RELEASE}"]
  output = ["type=image"]
  args = {
    SUI_RELEASE = SUI_RELEASE
  }
}

target "sui" {
  inherits = ["sui-node"]
  target = "sui"
  tags = ["ghcr.io/shinamicorp/sui:${SUI_RELEASE}"]
}

target "default" {
  inherits = ["sui-node"]
}
