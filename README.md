# Custom Deployer

Terraform module which delivers a Web Application artifact to the related Web Server by traditional deployment, powered by [Seal/Courier](https://registry.terraform.io/providers/seal-io/courier/latest).

## Usage

```hcl
module "custom-deployer" {
  source = "..."

  infrastructure = {
    runtime_source = "https://github.com/seal-io/terraform-provider-courier//pkg/runtime/source_builtin"
  }

  deployment = {
    rolling = {
      max_surge = 0.25
    }
  }

  target = {
    addresses = [...]
    authn = {
      mode   = "ssh"
      user   = "ansible"
      secret = "ansible"  # either password or token.
    }
  }

  artifact = {
    runtime_class = "tomcat"
    refer = {
      uri = "https://tomcat.apache.org/tomcat-7.0-doc/appdev/sample/sample.war"
      ports = [ 80 ]
    }
  }
}
```

## Examples

- [Multipass](./examples/multipass)

## Contributing

Please read our [contributing guide](./docs/CONTRIBUTING.md) if you're interested in contributing to Walrus template.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_courier"></a> [courier](#requirement\_courier) | >= 0.0.8 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_courier"></a> [courier](#provider\_courier) | >= 0.0.8 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [courier_deployment.deployment](https://registry.terraform.io/providers/seal-io/courier/latest/docs/resources/deployment) | resource |
| [courier_artifact.artifact](https://registry.terraform.io/providers/seal-io/courier/latest/docs/data-sources/artifact) | data source |
| [courier_runtime.runtime](https://registry.terraform.io/providers/seal-io/courier/latest/docs/data-sources/runtime) | data source |
| [courier_target.target](https://registry.terraform.io/providers/seal-io/courier/latest/docs/data-sources/target) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_context"></a> [context](#input\_context) | Receive contextual information. When Walrus deploys, Walrus will inject specific contextual information into this field.<br><br>Examples:<pre>context:<br>  project:<br>    name: string<br>    id: string<br>  environment:<br>    name: string<br>    id: string<br>  resource:<br>    name: string<br>    id: string</pre> | `map(any)` | `{}` | no |
| <a name="input_infrastructure"></a> [infrastructure](#input\_infrastructure) | Specify the infrastructure information for deploying.<br><br>Examples:<pre>infrastructure:<br>  runtime_source: string, optional</pre> | <pre>object({<br>    runtime_source = optional(string, null)<br>  })</pre> | `{}` | no |
| <a name="input_deployment"></a> [deployment](#input\_deployment) | Specify the deployment action, like scheduling, progress time and so on.<br><br>Examples:<pre>deployment:<br>  timeout: number, optional<br>  rolling: <br>    max_surge: number, optional          # in fraction, i.e. 0.25, 0.5, 1</pre> | <pre>object({<br>    timeout = optional(number, 300)<br>    rolling = optional(object({<br>      max_surge = optional(number, 0.25)<br>    }))<br>  })</pre> | <pre>{<br>  "rolling": {<br>    "max_surge": 0.25<br>  },<br>  "timeout": 300<br>}</pre> | no |
| <a name="input_artifact"></a> [artifact](#input\_artifact) | Specify the artifact of deployment, like a docker image, a war file and so on.<br><br>Examples:<pre>artifact:<br>  runtime_class: string, optional<br>  refer:<br>    uri: string<br>    insecure: bool, optional<br>    authn:<br>      mode: none/bearer/basic<br>      user: string, optional<br>      secret: string, optional<br>  command: string, optional<br>  ports: list(number), optional<br>  envs: map(string), optional<br>  volumes: list(string), optional      # used for docker runtime class</pre><pre></pre> | <pre>object({<br>    runtime_class = optional(string, "tomcat")<br>    refer = object({<br>      uri      = string<br>      insecure = optional(bool, false)<br>      authn = optional(object({<br>        mode   = optional(string, "none")<br>        user   = optional(string)<br>        secret = optional(string)<br>      }))<br>    })<br>    command = optional(string)<br>    ports   = optional(list(number))<br>    envs    = optional(map(string))<br>    volumes = optional(list(string))<br>  })</pre> | n/a | yes |
| <a name="input_target"></a> [target](#input\_target) | Specify the target of deployment, include the address list of target, authentication information and so on.<br><br>Examples:<pre>target:<br>  addresses: list(string)<br>  insecure: bool, optional<br>  authn:<br>    mode: ssh/winrm<br>    user: string<br>    secret: string<br>  proxies:<br>  - address: string<br>    insecure: bool, optional<br>    authn:<br>      mode: proxy/ssh<br>      user: string<br>      secret: string</pre> | <pre>object({<br>    addresses = list(string)<br>    insecure  = optional(bool, false)<br>    authn = object({<br>      mode   = optional(string, "ssh")<br>      user   = string<br>      secret = string<br>    })<br>    proxies = optional(list(object({<br>      address  = string<br>      insecure = optional(bool, false)<br>      authn = object({<br>        mode   = string<br>        user   = optional(string)<br>        secret = optional(string)<br>      })<br>    })))<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_context"></a> [context](#output\_context) | The input context, a map, which is used for orchestration. |
| <a name="output_refer"></a> [refer](#output\_refer) | The refer, a map, which is used for dependencies or collaborations. |
| <a name="output_connection"></a> [connection](#output\_connection) | The connection, a string combined host and port, might be a comma separated string or a single string. |
| <a name="output_address"></a> [address](#output\_address) | The address, a string only has host, might be a comma separated string or a single string. |
| <a name="output_ports"></a> [ports](#output\_ports) | The port list of the service. |
| <a name="output_endpoints"></a> [endpoints](#output\_endpoints) | The endpoints, a list of string combined host and port. |
<!-- END_TF_DOCS -->

## License

Copyright (c) 2023 [Seal, Inc.](https://seal.io)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at [LICENSE](./LICENSE) file for details.

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
