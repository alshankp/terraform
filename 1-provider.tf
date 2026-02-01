provider  "aws" {
    region = local.region
}

terraform {
    required_version = ">=v1.14.3"


    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
      }
    }
}
