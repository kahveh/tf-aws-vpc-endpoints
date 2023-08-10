variable "vpc_id" {
  type        = string
  description = "Existing VPC ID"
}

variable "service" {
  type        = string
  description = "Service name"
}

variable "service_type" {
  type        = string
  description = "Service type (Interface | Gateway)"
  default     = null
}

variable "policy" {
  type        = string
  description = "A policy to attach to the endpoint that controls access to the service. This is a JSON formatted string. Defaults to full access"
  default     = null
}

variable "auto_accept" {
  type        = bool
  description = "Accept the VPC endpoint"
  default     = null
}

variable "security_group_ids" {
  type        = list(string)
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

variable "timeouts" {
  description = "Define maximum timeout for creating, updating, and deleting VPC endpoint resources"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "A map of tags to use on all resources"
  type        = map(string)
  default     = {}
}
