output "Visualizer DNS" {
  value = "https://${aws_route53_record.viz_elb.name}"
}
