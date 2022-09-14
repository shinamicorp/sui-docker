variable "SUI_RELEASE" {
  default = "devnet-0.9.0"
}

target "sui-node" {
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
