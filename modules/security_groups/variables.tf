variable "vpc_id" {
  type        = string
  description = "Existing VPC ID"
}

variable "services" {
  description = "Optional list of services for security group description"
  type        = list(string)
  default     = []
}

variable "auto_accept" {
  description = "Accept the VPC endpoint"
  type        = bool
  default     = null
}
variable "custom_ingress_cidrs" {
  description = "List of IP addresses/network cidr to be allowed in the ingress security group"
  type        = list(string)
  default     = null # sample ["1.2.3.4/32"] or ["1.2.3.4/32", "10.0.0.0/8"]
}


variable "security_group_name" {
  description = "Name to use on security group created. Conflicts with `security_group_name_prefix`"
  type        = string
  default     = null
}

variable "security_group_name_prefix" {
  description = "Name prefix to use on security group created. Conflicts with `security_group_name`"
  type        = string
  default     = null
}

variable "security_group_description" {
  description = "Optional Description of the security group created"
  type        = string
  default     = null
}

variable "security_group_rules" {
  description = "Security group rules to add to the security group created"
  type        = any
  default     = {
    default = {
      cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
    }
  }
}

variable "tags" {
  description = "A map of tags to use on all resources"
  type        = map(string)
  default     = {}
}
