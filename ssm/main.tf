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
    "ssm", # Systems Manager service
    "ec2messages", # SSM Agent to make calls to the Systems Manager service
    "ssmmessages" # Connecting to EC2 instances through a secure data channel using Session Manager
  ]
  optional_services = [
    "ec2", # Systems Manager to create VSS-enabled snapshots
    "kms", #  AWS Key Management Service (AWS KMS) encryption for Session Manager or Parameter Store parameters
    "logs" # Amazon CloudWatch Logs (CloudWatch Logs) for Session Manager, Run Command, or SSM Agent logs
  ]
  services = concat(var.enable_optional_endpoints ? local.optional_services : [], local.required_services)
}

module "security_group" {
  count  = var.create_security_group ? 1 : 0
  source = "../modules/security_groups"

  vpc_id = var.vpc_id

  services = local.services
  security_group_name = "vpc-endpoint-ssm"
}


module "endpoints" {
  for_each = toset(local.services)
  source   = "../modules/endpoint"

  vpc_id              = var.vpc_id
  service             = each.key
  security_group_ids  = var.security_group_ids
  policy              = var.policy
  auto_accept         = var.auto_accept
  private_dns_enabled = var.private_dns_enabled
  subnet_ids          = var.subnet_ids
  route_table_ids     = var.route_table_ids

  tags = {
    Name = "${try(data.aws_vpc.this.tags.Name, var.vpc_id)}-${each.key}"
  }
}