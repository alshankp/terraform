locals {
    env         =  "staging"
    region      =  "ap-south-1"
    zone1       =  "ap-south-1a"
    zone2       =  "ap-south-1b"
    eks_name    =  "demo"
    eks_version =  "1.29"

    cluster_full_name = "${local.env}-${local.eks_name}"

}