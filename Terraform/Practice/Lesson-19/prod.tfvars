# Auto-fill for DEV

region              = "us-west-1"
instance_type       = "t2.micro"
detailed_monitoring = false

allow_ports = ["80", "443"]

common_tags = {
  Owner       = "Alexey Tozik"
  Project     = "Bugatti"
  Environment = "production"
}

