# Install AWS Control Tower Account Factory for Terraform 

## Prepare Root account 
  * Log in to Root acccount as root user.
  * [Enable MFA for Root account](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_mfa_enable_virtual.html#enable-virt-mfa-for-root)
  * [Create billing alarm](https://aws.amazon.com/blogs/mt/setting-up-an-amazon-cloudwatch-billing-alarm-to-proactively-monitor-estimated-charges/)

## Control Tower 
  * Create Control Tower in your desired region, specify needed OU's + OU 'AFT-Management'.
  * Create SSO-user(s)

## Installation 
  * Set environment variable AWS\_REGION to the region where AWS Control Tower is provisioned.
  * Review and change if needed aft module settings in aft-management.tf
  * Run terraform apply 
 
