output "log_account" {
  value = local.log_account_id
}

output "audit_account" {
  value = local.audit_account_id
}

output "mgmt_account" {
  value = controltower_aws_account.aft_management.account_id
}

output "ct_mgmt_account" {
  value = data.aws_caller_identity.current.account_id
}

