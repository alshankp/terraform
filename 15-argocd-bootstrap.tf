resource "null_resource" "argocd_post_install" {

  depends_on = [
    aws_eks_cluster.eks,
    aws_iam_openid_connect_provider.eks
  ]

  # This prevents re-running unless cluster changes
  triggers = {
    cluster_id = aws_eks_cluster.eks.id
  }

  provisioner "local-exec" {

    command = "bash ${path.module}/Argocd/install.sh"
  }
}
