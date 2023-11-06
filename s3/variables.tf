variable "vpc_id" {
  type        = string
  description = "Existing VPC ID"
}

variable "create_security_group" {
  type        = bool
  default     = false
  description = "Create default security group for inbound traffic"
}

variable "enable_optional_endpoints" {
  description = "Enable EC2, KMS, and Cloudwatch Logs service endpoints"
  type        = bool
  default     = true
}

variable "policy" {
  type        = string
  description = "A policy to attach to the endpoint that controls access to the service. This is a JSON formatted string. Defaults to full access"
  default     = null
}

variable "auto_accept" {
  type        = bool
  default     = null
  description = "Accept the VPC endpoint"
}

variable "security_group_ids" {
  type        = list(string)
  default     = []
  description = "Existing Security Group IDs"
}

variable "private_dns_enabled" {
  type        = bool
  default     = true
  description = "Boolean to associate a private hosted zone with the specified VPC"
}

variable "subnet_ids" {
  description = "Default subnets IDs to associate with the VPC endpoints"
  type        = list(string)
  default     = []
}

variable "route_table_ids" {
  description = "Default subnets IDs to associate with the VPC endpoints"
  type        = list(string)
  default     = []
}