terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    controltower = {
      source  = "idealo/controltower"
      version = "1.3.0"
    }
  }
}

provider "aws" {
  region      = "${ct_home_region}"
  max_retries = 10
}

resource "controltower_aws_account" "aft_management" {
  name                = "AFT-Management"
  email               = "${aft_acc_root_email}"
  organizational_unit = "${aft_acc_ou}"

  sso {
    first_name = "${aft_acc_sso_first_name}"
    last_name  = "${aft_acc_sso_last_name}"
    email      = "${aft_acc_sso_email}"
  }
}

module "aft" {
  source = "github.com/aws-ia/terraform-aws-control_tower_account_factory?ref=1.6.6"
 
  # Required Vars
  account_customizations_repo_branch = "main"
  ct_management_account_id    = "${ct_management_account_id}"
  log_archive_account_id      = "${log_account_id}"
  audit_account_id            = "${audit_account_id}"
  aft_management_account_id   = controltower_aws_account.aft_management.account_id
  ct_home_region              = "${ct_home_region}"
  tf_backend_secondary_region = "${ct_secondary_region}"

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
