locals {
  progress_timeout = format("%ds", try(var.deployment.timeout != null && var.deployment.timeout > 0, false) ? var.deployment.timeout : 300)

  target_addresses = sort(distinct(var.target.addresses))
  artifact_ports   = try(sort(distinct(var.artifact.ports)), null)
}

#
# Ensure
#

data "courier_runtime" "runtime" {
  source = try(var.infrastructure.runtime_source, null)
  class  = try(var.artifact.runtime_class, null)
}

data "courier_target" "target" {
  count = length(local.target_addresses)

  host = {
    address  = local.target_addresses[count.index]
    insecure = try(var.target.insecure, false)
    authn = try(var.target.authn != null, false) ? {
      type   = try(var.target.authn.mode, "ssh")
      user   = var.target.authn.user
      secret = var.target.authn.secret
    } : null
    proxies = try(length(var.target.proxies) > 0, false) ? [
      for p in var.target.proxies : {
        address  = p.address
        insecure = try(p.insecure, false)
        authn = try(p.authn != null, false) ? {
          type   = try(p.authn.mode, "proxy")
          user   = try(p.authn.user, null)
          secret = try(p.authn.secret, null)
        } : null
      }
    ] : null
  }

  timeouts = {
    create = local.progress_timeout
    update = local.progress_timeout
  }
}

data "courier_artifact" "artifact" {
  refer = {
    uri      = var.artifact.refer.uri
    insecure = try(var.artifact.refer.insecure, false)
    authn = try(var.artifact.refer.authn != null, false) ? {
      type   = try(var.artifact.refer.authn.mode, "bearer")
      user   = try(var.artifact.refer.authn.user, null)
      secret = var.artifact.refer.authn.secret
    } : null
  }

  command = var.artifact.command
  ports   = local.artifact_ports
  envs    = var.artifact.envs
  volumes = var.artifact.volumes

  timeouts = {
    create = local.progress_timeout
    update = local.progress_timeout
  }
}

#
# Deployment
#

resource "courier_deployment" "deployment" {
  targets  = data.courier_target.target
  artifact = data.courier_artifact.artifact
  runtime  = data.courier_runtime.runtime

  strategy = {
    type = "rolling"
    rolling = try(var.infrastructure.rolling, {
      max_surge = 0.25
    })
  }

  timeouts = {
    create = local.progress_timeout
    update = local.progress_timeout
    delete = local.progress_timeout
  }
}
