output "main-ip" {
    value = aws_instance.gitlab.public_ip
}

output "runner1-ip" {
    value = aws_instance.runner1.private_ip
}

output "runner2-ip" {
    value = aws_instance.runner2.private_ip
}