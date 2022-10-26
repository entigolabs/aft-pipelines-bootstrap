variable "aft_management_account_root_email" {
  description = "Root user email for the AFT management account"
  type        = string
}

variable "aft_management_account_ou" {
  description = "AWS Organizations OU where the AFT management account will be created"
  type        = string
  default     = "AFT-Management"
}

variable "aft_management_account_sso_admin" {
  description = "SSO admin user for the AFT management account, this users e-mail must already exist in AWS SSO"
  type        = object({ first_name = string, last_name = string, email = string })
}

variable "aft_backup_region" {
  description = "Region where the backup copies of AFT terraform state files will be stored"
  type        = string
}

