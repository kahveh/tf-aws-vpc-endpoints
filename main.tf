module "ssm_endpoints" {
  count                 = contains(var.service_groups, "ssm") ? 1 : 0
  source                = "ssm"
  create_security_group = var.create_security_groups
  vpc_id                = var.vpc_id
}