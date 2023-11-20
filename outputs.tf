output "context" {
  description = "The input context, a map, which is used for orchestration."
  value       = var.context
}

output "endpoint_internal" {
  description = "The internal endpoints, a string list, which are used for internal access."
  value = flatten([
    for p in local.artifact_ports : formatlist("%s:%v", local.target_addresses, p)
  ])
}
