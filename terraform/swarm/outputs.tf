output "Visualizer DNS" {
  value = "https://${aws_route53_record.viz_elb.name}"
}

output "DEMO DNS" {
  value = "https://${aws_route53_record.demo_elb.name}"
}
