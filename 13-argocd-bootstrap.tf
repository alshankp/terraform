resource "null_resource" "install_argocd" {

  depends_on = [
    aws_eks_cluster.eks
  ]

  provisioner "local-exec" {

    command = <<EOT
      aws eks update-kubeconfig --name ${local.cluster_full_name} --region ${local.region}

      kubectl create namespace argocd || true

      kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

      kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj-labs/argocd-image-updater/stable/config/install.yaml
    EOT
  }
}
