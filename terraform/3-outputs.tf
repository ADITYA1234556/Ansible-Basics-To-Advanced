output "ec2ip" {
    value = {for key, instance in aws_instance.this : key => instance.public_ip}
  # value       = aws_instance.this.public_ip
  description = "Public IP of the EC2 instance"
}