#
# Contextual Fields
#

variable "context" {
  description = <<-EOF
Receive contextual information. When Walrus deploys, Walrus will inject specific contextual information into this field.

Examples:
```
context:
  project:
    name: string
    id: string
  environment:
    name: string
    id: string
  resource:
    name: string
    id: string
```
EOF
  type        = map(any)
  default     = {}
}

#
# Infrastructure Fields
#

variable "infrastructure" {
  description = <<-EOF
Specify the infrastructure information for deploying.

Examples:
```
infrastructure:
  runtime_source: string, optional
```
EOF
  type = object({
    runtime_source = optional(string, null)
  })
  default = {}
}

#
# Deployment Fields
#

variable "deployment" {
  description = <<-EOF
Specify the deployment action, like scheduling, progress time and so on.

Examples:
```
deployment:
  timeout: number, optional
  rolling: 
    max_surge: number, optional          # in fraction, i.e. 0.25, 0.5, 1
```
EOF
  type = object({
    timeout = optional(number, 300)
    rolling = optional(object({
      max_surge = optional(number, 0.25)
    }))
  })
  default = {
    timeout = 300
    rolling = {
      max_surge = 0.25
    }
  }
}

variable "artifact" {
  description = <<-EOF
Specify the artifact of deployment, like a docker image, a war file and so on.

Examples:
```
artifact:
  runtime_class: string, optional
  refer:
    uri: string
    insecure: bool, optional
    authn:
      mode: none/bearer/basic
      user: string, optional
      secret: string, optional
  command: string, optional
  ports: list(number), optional
  envs: map(string), optional
  volumes: list(string), optional      # used for docker runtime class
```
```
EOF
  type = object({
    runtime_class = optional(string, "tomcat")
    refer = object({
      uri      = string
      insecure = optional(bool, false)
      authn = optional(object({
        mode   = optional(string, "none")
        user   = optional(string)
        secret = optional(string)
      }))
    })
    command = optional(string)
    ports   = optional(list(number))
    envs    = optional(map(string))
    volumes = optional(list(string))
  })
}

variable "target" {
  description = <<-EOF
Specify the target of deployment, include the address list of target, authentication information and so on.

Examples:
```
target:
  addresses: list(string)
  insecure: bool, optional
  authn:
    mode: ssh/winrm
    user: string
    secret: string
  proxies:
  - address: string
    insecure: bool, optional
    authn:
      mode: proxy/ssh
      user: string
      secret: string
```
EOF
  type = object({
    addresses = list(string)
    insecure  = optional(bool, false)
    authn = object({
      mode   = optional(string, "ssh")
      user   = string
      secret = string
    })
    proxies = optional(list(object({
      address  = string
      insecure = optional(bool, false)
      authn = object({
        mode   = string
        user   = optional(string)
        secret = optional(string)
      })
    })))
  })
}
