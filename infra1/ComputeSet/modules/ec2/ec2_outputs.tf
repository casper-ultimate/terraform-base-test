output "host_eip" {
  value = aws_eip.host_addr.*.public_ip
}

output "host_instance" {
  value = aws_instance.host_instance.id
}