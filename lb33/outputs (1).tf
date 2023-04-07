output "apacheurl" {
  value = format("http://%s", aws_instance.Apache2.public_ip)
}