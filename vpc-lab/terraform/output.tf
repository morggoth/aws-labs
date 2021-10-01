output "vpc_arn" {
  value = aws_vpc.lab.arn
}

output "public_subnet_arn" {
  value = aws_subnet.public.arn
}

output "private_subnet_arn" {
  value = aws_subnet.private.arn
}

output "ec2_public_ip" {
  value = aws_instance.public.public_ip
}

output "ec2_public_dns" {
  value = aws_instance.public.public_dns
}

output "public_ec2_connection_string" {
  value = "ssh ec2-user@${aws_instance.public.public_ip} -i ${path.module}/files/vpc-lab-public"
}