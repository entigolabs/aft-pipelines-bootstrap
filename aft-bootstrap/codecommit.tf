locals {
  accounts         = data.aws_organizations_organization.controltower.accounts[*]
  log_account_id   = local.accounts[index(local.accounts[*].name, "Log Archive")].id
  audit_account_id = local.accounts[index(local.accounts[*].name, "Audit")].id
  ct_region        = data.aws_region.current.name
  path             = abspath(path.root)
}

# Create and populate repository

resource "aws_codecommit_repository" "aft_provisioner" {
  repository_name = "aft-provisioner"
  description     = "This repo holds the AFT provisioning solution"
  default_branch  = "main"
}

resource "null_resource" "push_provisioner_to_repo" {
  provisioner "local-exec" {
    command = <<-EOS
      rm -rf aft-provisioner-cloned aft-provisioner
      mkdir -p aft-provisioner
      cp ${path.module}/templates/.gitconfig ${local.path}/.gitconfig
      HOME="${local.path}" git clone ${aws_codecommit_repository.aft_provisioner.clone_url_http} aft-provisioner-cloned
      [ -f aft-provisioner-cloned/.bootstrap ] && exit 0
      cp aft-provisioner/*.tf* aft-provisioner-cloned/
      touch aft-provisioner-cloned/.bootstrap
      HOME="${local.path}" git -C aft-provisioner-cloned add .
      HOME="${local.path}" git -C aft-provisioner-cloned commit -m 'Initial provisoning of AFT'
      HOME="${local.path}" git -C aft-provisioner-cloned push origin main
EOS
  }
  depends_on = [aws_codecommit_repository.aft_provisioner, local_file.main_tf]
}

resource "local_file" "main_tf" {
  content = templatefile("${path.module}/templates/main.tf.tpl", {
    aft_acc_root_email       = var.aft_management_account_root_email,
    aft_acc_ou               = var.aft_management_account_ou,
    aft_acc_sso_first_name   = var.aft_management_account_sso_admin.first_name
    aft_acc_sso_last_name    = var.aft_management_account_sso_admin.last_name
    aft_acc_sso_email        = var.aft_management_account_sso_admin.email
    ct_management_account_id = data.aws_caller_identity.current.account_id
    log_account_id           = local.log_account_id
    audit_account_id         = local.audit_account_id
    ct_home_region           = local.ct_region
    ct_secondary_region      = var.aft_backup_region
  })
  filename = "${path.root}/aft-provisioner/main.tf"
}
