variable "vpc_id" {
  type        = string
  description = "Existing VPC ID"
}

variable "create_security_groups" {
  type        = bool
  default     = false
  description = "Create default security groups for inbound traffic"
}

variable "service_groups" {
  type        = list(string)
  default     = []
  description = "List of common service groups to enable for this VPC"
}