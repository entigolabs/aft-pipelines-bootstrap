output "account_ids" {
  value = data.aws_organizations_organization.controltower.accounts[*].id
}

output "organizational_units" {
  value = data.aws_organizations_organizational_units.ou.children[*].name
}

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}

output "caller_user" {
  value = data.aws_caller_identity.current.user_id
}


output "log_account" {
  value = local.log_account_id
}

output "audit_account" {
  value = local.audit_account_id
}

output "ct_mgmt_account" {
  value = data.aws_caller_identity.current.account_id
}

