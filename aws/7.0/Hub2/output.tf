
output "FGTPublicIP1" {
  value = aws_eip.FGTPublicIP1.public_ip
}
output "FGTPublicIP2" {
  value = aws_eip.FGTPublicIP2.public_ip
}
output "Username" {
  value = "admin"
}

output "Password" {
  value = aws_instance.fgtvm-hub2.id
}

