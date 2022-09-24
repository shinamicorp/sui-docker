variable "SUI_RELEASE" {
  default = "devnet-0.9.0"
}

variable "PLATFORM" {
  default = "linux/amd64"
}

function "tag" {
  params = [target]
  result = ["ghcr.io/shinamicorp/${target}:${SUI_RELEASE}-${regex_replace(PLATFORM, "/", "-")}"]
}

target "sui-node" {
  # We gave up on cross-compilation of Sui because it kept hitting memory limit.
  # So we'll build one platform image at a time and rely on manual manifest creation afterwards.
  platforms = [PLATFORM] 
  tags = tag("sui-node")
  output = ["type=image"]
  args = {
    SUI_RELEASE = SUI_RELEASE
  }
}

target "sui" {
  inherits = ["sui-node"]
  target = "sui"
  tags = tag("sui")
}

target "test" {
  inherits = ["sui-node"]
  dockerfile = "Dockerfile.test"
  tags = tag("test")
}

target "default" {
  inherits = ["sui-node"]
}
