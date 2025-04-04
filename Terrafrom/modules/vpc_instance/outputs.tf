output "instance_details" {
  description = "Details of all created instances"
  value = {
    for group, instances in aws_instance.group_instances :
    group => {
      instance_ids = instances[*].id
      public_ips  = instances[*].public_ip
      private_ips = instances[*].private_ip
      names       = [for i, v in instances : v.tags.Name]
    }
  }
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "subnet_id" {
  description = "ID of the subnet"
  value       = aws_subnet.main.id
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.allow_ssh.id
}