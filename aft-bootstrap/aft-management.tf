
locals {
  accounts         = data.aws_organizations_organization.controltower.accounts[*]
  log_account_id   = local.accounts[index(local.accounts[*].name,"Log Archive")].id
  audit_account_id = local.accounts[index(local.accounts[*].name,"Audit")].id
  mgmt_account_id  = local.accounts[index(local.accounts[*].name,"AFT-Management")].id
  ct_region        = data.aws_region.current.name 
}

resource "controltower_aws_account" "aft_management" {
  name                = "AFT-Management"
  email               = "rnd-aws+aft-management@entigo.com"
  organizational_unit = "AFT-Management"

  sso {
    first_name = "Priit"
    last_name  = "Randla"
    email      = "priit.randla@entigo.com"
  }
}

module "aft" {
  source = "github.com/aws-ia/terraform-aws-control_tower_account_factory?ref=1.6.6"
 
  # Required Vars
  account_customizations_repo_branch = "main"
  ct_management_account_id    = data.aws_caller_identity.current.account_id
  log_archive_account_id      = local.log_account_id
  audit_account_id            = local.audit_account_id
  aft_management_account_id   = controltower_aws_account.aft_management.account_id
  ct_home_region              = local.ct_region
  tf_backend_secondary_region = local.ct_region != "eu-west-1" ? "eu-west-1" : "eu-north-1"

  aft_metrics_reporting = false
  aft_feature_enterprise_support = false
  aft_feature_delete_default_vpcs_enabled = true
  aft_vpc_endpoints = false
  
  aft_vpc_cidr                   = "10.250.0.0/22"
  aft_vpc_private_subnet_01_cidr = "10.250.0.0/24"
  aft_vpc_private_subnet_02_cidr = "10.250.1.0/24"
  aft_vpc_public_subnet_01_cidr  = "10.250.2.0/25"
  aft_vpc_public_subnet_02_cidr  = "10.250.2.128/25"
}
