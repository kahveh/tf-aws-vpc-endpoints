data "aws_region" "current" {}
data "aws_vpc" "this" {
  id = var.vpc_id
}

# ---------------------------------------------------------------------------------------------------------------------
# Influenced by:
# - https://github.com/bayupw/terraform-aws-ssm-vpc-endpoint/blob/main/main.tf
# References:
# - https://aws.amazon.com/premiumsupport/knowledge-center/ec2-systems-manager-vpc-endpoints/
# - https://docs.aws.amazon.com/systems-manager/latest/userguide/setup-create-vpc.html#sysman-setting-up-vpc-create
# ---------------------------------------------------------------------------------------------------------------------

locals {
  required_services = [
    "s3", # Simple Storage Solution
  ]
  optional_services = [
  ]
  services = concat(var.enable_optional_endpoints ? local.optional_services : [], local.required_services)
}

module "security_group" {
  count  = var.create_security_group ? 1 : 0
  source = "../modules/security_groups"

  vpc_id = var.vpc_id

  services            = local.services
  security_group_name = "vpc-endpoint-s3"
}


module "endpoints" {
  for_each = toset(local.services)
  source   = "../modules/endpoint"

  vpc_id              = var.vpc_id
  service             = each.key
  security_group_ids  = []
  policy              = var.policy
  auto_accept         = var.auto_accept
  private_dns_enabled = var.private_dns_enabled
  subnet_ids          = var.subnet_ids
  route_table_ids     = var.route_table_ids
  service_type        = "Gateway"

  tags = {
    Name = "${try(data.aws_vpc.this.tags.Name, var.vpc_id)}-${each.key}"
  }
}