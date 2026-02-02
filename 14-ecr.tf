resource "aws_ecr_repository" "microservices" {

  for_each = toset([
    "frontend",
    "cartservice",
    "checkoutservice",
    "currencyservice",
    "emailservice",
    "paymentservice",
    "productcatalogservice",
    "recommendationservice",
    "shippingservice",
    "adservice"
  ])

  name = each.key

  image_scanning_configuration {
    scan_on_push = true
  }

  image_tag_mutability = "IMMUTABLE"

  tags = {
    Environment = "staging"
    ManagedBy   = "terraform"
  }
}
