terraform {
  required_version = ">= 1.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 2.1"
    }
  }
}
