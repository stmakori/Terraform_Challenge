resource "aws_route53_record" "app" {
  zone_id = var.zone_id
  name    = var.domain
  type    = "A"

  alias {
    name                   = var.alb_dns
    zone_id                = var.alb_zone
    evaluate_target_health = true
  }
}
