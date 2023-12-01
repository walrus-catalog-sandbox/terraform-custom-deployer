terraform {
  required_version = ">= 1.0"

  required_providers {
    multipass = {
      source  = "larstobi/multipass"
      version = ">= 1.4.2"
    }
    courier = {
      source  = "seal-io/courier"
      version = ">= 0.0.9"
    }
  }
}

provider "multipass" {}

resource "multipass_instance" "example" {
  count = 3

  name           = format("courier-%d", count.index)
  memory         = "512M"
  cloudinit_file = abspath("./config/cloud-init.yaml")
}

data "multipass_instance" "example" {
  count = try(length(multipass_instance.example), 0)

  name = format("courier-%d", count.index)

  lifecycle {
    postcondition {
      condition     = self.state == "Running"
      error_message = "Invaild multipass instance, ${self.name} is not running"
    }
  }

  depends_on = [
    multipass_instance.example
  ]
}

provider "courier" {}

module "this" {
  source = "../.."

  infrastructure = {
    runtime_source = "https://github.com/seal-io/terraform-provider-courier//pkg/runtime/source_builtin"
  }

  target = {
    addresses = data.multipass_instance.example[*].ipv4
    authn = {
      type   = "ssh"
      user   = "ansible"
      secret = "ansible"
    }
  }

  artifact = {
    runtime_class = "tomcat"
    refer = {
      uri = "https://tomcat.apache.org/tomcat-7.0-doc/appdev/sample/sample.war"
    }
    ports = [80]
  }
}

output "context" {
  value = module.this.context
}

output "refer" {
  value = nonsensitive(module.this.refer)
}

output "connection" {
  value = module.this.connection
}

output "address" {
  value = module.this.address
}

output "ports" {
  value = module.this.ports
}

output "endpoints" {
  value = module.this.endpoints
}
