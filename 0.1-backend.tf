terraform {
  backend "s3" {
   bucket               = "devshan-eks-tfstate-667516053986"
   key                  = "dev/eks/terraform.tfstate"
   region               = "ap-south-1"
   encrypt              = true
  }
}