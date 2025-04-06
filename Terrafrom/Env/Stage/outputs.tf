output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_id" {
  value = aws_subnet.main.id
}

output "instance_ids" {
  value = [for instance in aws_instance.group_instances : instance.id]
}