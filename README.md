# tf-aws-vpc-endpoints
A set of modules to create a VPC endpoints, or set of VPC endpoints based on a service grouping.

## Groups

| Group Name  | Required Services             | Optional Services |
|-------------|-------------------------------|-------------------|
| ssm         | ssm, ec2messages, ssmmessages | ec2,kms,logs      |

## Default use

Using a pre-made endpoint group such as SSM:
```terraform
module "ssm_endpoints" {
  source                = "git::https://github.com/kahveh/tf-aws-vpc-endpoints.git//ssm"
  vpc_id                = var.vpc_id
  create_security_group = var.create_security_groups
}
```

Will create both required and optional services by default.

If you include the base module:

```terraform
module "endpoints" {
  source         = "git::https://github.com/kahveh/tf-aws-vpc-endpoints.git"
  vpc_id         = var.vpc_id
  create_security_group = var.create_security_groups
  service_groups = [
    "ssm"
  ]
  # services // TODO: To define individual services in base module
}
```

You can define multiple service groups.
# TODO: Enable default service_groups behavior // description: or all if `service_groups` is not defined.