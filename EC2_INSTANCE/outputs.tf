output "nginx_public_ip" {
  value = aws_instance.nginx-instance.public_ip
}
output "jenkins_public_ip" {
  value = aws_instance.jenkins-instance.public_ip
}