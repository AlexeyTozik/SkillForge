# По умолчанию string
# Terraform сам пытается определить тип

variable "region" {
  description = "Please enter AWS region (default: us-east-1)"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "Enter instance type (default: t2.nano)"
  type        = string
  default     = "t2.nano"
}

variable "allow_ports" {
  description = "List of ports to open"
  type        = list(any)
  default     = ["80", "443", "22", "8080"]
}

variable "detailed_monitoring" {
  type    = bool
  default = true
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(any)
  default = {
    Owner       = "Alexey Tozik"
    Project     = "Bugatti"
    Environment = "development"
  }
}
