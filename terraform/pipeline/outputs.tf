output "Jenkins DNS" {
  value = "https://${aws_route53_record.jenkins_master.name}"
}
