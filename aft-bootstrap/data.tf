data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_organizations_organization" "controltower" {}

data "aws_organizations_organizational_units" "ou" {
  parent_id = data.aws_organizations_organization.controltower.roots[0].id
}

output "account_ids" {
  value = data.aws_organizations_organization.controltower.accounts[*].id
}

output "organizational_units" {
  value = data.aws_organizations_organizational_units.ou.children[*].name
}
