# ---------------------------------------------------------------------------------------------------------------------
# Influenced by https://github.com/terraform-aws-modules/terraform-aws-vpc/blob/master/modules/vpc-endpoints/main.tf
# ---------------------------------------------------------------------------------------------------------------------

locals {
  rfc1918       = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
  ingress_cidrs = try(var.custom_ingress_cidrs, local.rfc1918)
  description   = try(var.security_group_description, "Allow TLS inbound traffic for ${join(" ,", try(var.services, "vpc service"))} endpoints")
}

data "aws_vpc" "this" {
  id = var.vpc_id
}

resource "aws_security_group" "this" {
  vpc_id      = var.vpc_id
  name        = var.security_group_name
  name_prefix = var.security_group_name_prefix
  description = local.description

  tags = merge(
    var.tags,
    { "Name" = try(coalesce(var.security_group_name, var.security_group_name_prefix), "") },
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "this" {
  for_each = {for k, v in var.security_group_rules : k => v}

  # Required
  security_group_id = aws_security_group.this.id
  protocol          = try(each.value.protocol, "tcp")
  from_port         = try(each.value.from_port, 443)
  to_port           = try(each.value.to_port, 443)
  type              = try(each.value.type, "ingress")

  # Optional
  description = try(each.value.description, null)

  cidr_blocks = each.key == "default" ? [
    data.aws_vpc.this.cidr_block
  ] : lookup(each.value, "cidr_blocks", null)

  ipv6_cidr_blocks         = lookup(each.value, "ipv6_cidr_blocks", null)
  prefix_list_ids          = lookup(each.value, "prefix_list_ids", null)
  self                     = try(each.value.self, null)
  source_security_group_id = lookup(each.value, "source_security_group_id", null)
}