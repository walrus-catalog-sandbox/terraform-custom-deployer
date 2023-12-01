terraform {
  required_version = ">= 1.0"

  required_providers {
    courier = {
      source  = "seal-io/courier"
      version = ">= 0.0.9"
    }
  }
}
