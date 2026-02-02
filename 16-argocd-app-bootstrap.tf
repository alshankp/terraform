resource "null_resource" "argocd_app_apply" {

  depends_on = [
    null_resource.argocd_post_install
  ]

  triggers = {
    app_hash = filesha1("${path.module}/Argocd/app.yml")
  }

  provisioner "local-exec" {
    command = "kubectl apply -f ${path.module}/Argocd/app.yml"
  }
}
