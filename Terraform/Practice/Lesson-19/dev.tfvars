# Auto-fill for DEV

region              = "us-west-1"
instance_type       = "t2.nano"
detailed_monitoring = false

allow_ports = ["80", "443", "22", "8080"]

common_tags = {
  Owner       = "Alexey Tozik"
  Project     = "Bugatti"
  Environment = "development"
}

