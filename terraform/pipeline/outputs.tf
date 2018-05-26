output "Jenkins DNS" {
  value = "https://${aws_route53_record.jenkins_master.name}"
}

output "Nexus DNS" {
  value = "https://${aws_route53_record.nexus.name}"
}

output "Registry DNS" {
  value = "https://${aws_route53_record.registry.name}"
}

output "Jenkins SG ID" {
  value = "${aws_security_group.jenkins_master_sg.id}"
}
