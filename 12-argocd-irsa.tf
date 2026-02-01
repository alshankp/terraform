############################################
# Get EKS OIDC Provider (Direct Resource)
############################################

data "aws_iam_openid_connect_provider" "eks" {
  url = aws_eks_cluster.eks.identity[0].oidc[0].issuer
}

############################################
# Local Helper
############################################

locals {
  eks_oidc_provider = trimprefix(
    aws_eks_cluster.eks.identity[0].oidc[0].issuer,
    "https://"
  )
}

############################################
# IRSA Role
############################################

resource "aws_iam_role" "argocd_image_updater_role" {

  name = "argocd-image-updater-ecr-role"

  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Federated = data.aws_iam_openid_connect_provider.eks.arn
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
# Attach ECR Permission
############################################

resource "aws_iam_role_policy_attachment" "argocd_image_updater_ecr" {

  role       = aws_iam_role.argocd_image_updater_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}
