# ---------------------------------------------------------------------------------------------------------------------
# Influenced by https://github.com/terraform-aws-modules/terraform-aws-vpc/blob/master/modules/vpc-endpoints/main.tf
# ---------------------------------------------------------------------------------------------------------------------

locals {
  service_type        = try(data.aws_vpc_endpoint_service.this.service_type, "Interface")
  security_group_ids  = local.service_type == "Interface" ? length(try(var.security_group_ids, [])) > 0 ? distinct(var.security_group_ids) : null : null
  subnet_ids          = local.service_type == "Interface" ? distinct(try(var.subnet_ids, [])) : null
  route_table_ids     = local.service_type == "Gateway" ? try(var.route_table_ids, null) : null
  private_dns_enabled = local.service_type == "Interface" ? try(var.private_dns_enabled, null) : null
}

data "aws_vpc_endpoint_service" "this" {
  service_name = var.service_name

  filter {
    name   = "service-type"
    values = [try(var.service_type, "Interface")]
  }
}

resource "aws_vpc_endpoint" "ec2_endpoint" {
  vpc_id            = var.vpc_id
  service_name      = data.aws_vpc_endpoint_service.this.service_name
  vpc_endpoint_type = local.service_type
  auto_accept       = try(var.auto_accept, null)
  policy            = try(var.policy, null)

  security_group_ids  = local.security_group_ids
  subnet_ids          = local.subnet_ids
  route_table_ids     = local.route_table_ids
  private_dns_enabled = local.private_dns_enabled

  tags = var.tags
  timeouts {
    create = try(var.timeouts.create, "10m")
    update = try(var.timeouts.update, "10m")
    delete = try(var.timeouts.delete, "10m")
  }
}
