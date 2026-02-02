############################################
# Fetch EKS OIDC TLS Certificate (Dynamic)
############################################

data "tls_certificate" "eks_oidc" {
  url = aws_eks_cluster.eks.identity[0].oidc[0].issuer
}

############################################
# Create IAM OIDC Provider (Dynamic)
############################################

resource "aws_iam_openid_connect_provider" "eks" {

  url = aws_eks_cluster.eks.identity[0].oidc[0].issuer

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    data.tls_certificate.eks_oidc.certificates[0].sha1_fingerprint
  ]
}

############################################
# Local Helper (OIDC URL without https)
############################################

locals {
  eks_oidc_provider = trimprefix(
    aws_eks_cluster.eks.identity[0].oidc[0].issuer,
    "https://"
  )
}

############################################
# ArgoCD Image Updater IRSA Role
############################################

resource "aws_iam_role" "argocd_image_updater_role" {

  name = "argocd-image-updater-ecr-role"

  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Federated = aws_iam_openid_connect_provider.eks.arn
        }

        Action = "sts:AssumeRoleWithWebIdentity"

        Condition = {
          StringEquals = {
            "${local.eks_oidc_provider}:sub" = "system:serviceaccount:argocd:argocd-image-updater-controller"
          }
        }
      }
    ]
  })
}

############################################
# Attach ECR Read Permission
############################################

resource "aws_iam_role_policy_attachment" "argocd_image_updater_ecr" {

  role       = aws_iam_role.argocd_image_updater_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}
