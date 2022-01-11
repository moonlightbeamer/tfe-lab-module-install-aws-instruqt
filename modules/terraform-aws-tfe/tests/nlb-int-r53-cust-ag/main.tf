terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.64.2"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "tfe" {
  source = "../.."

  friendly_name_prefix = var.friendly_name_prefix
  common_tags          = var.common_tags

  tfe_bootstrap_bucket            = var.tfe_bootstrap_bucket
  tfe_license_filepath            = var.tfe_license_filepath
  airgap_install                  = var.airgap_install
  pkg_repos_reachable_with_airgap = var.pkg_repos_reachable_with_airgap
  tfe_airgap_bundle_path          = var.tfe_airgap_bundle_path
  replicated_bundle_path          = var.replicated_bundle_path
  tfe_hostname                    = var.tfe_hostname
  tls_bootstrap_type              = var.tls_bootstrap_type
  tfe_cert_secret_arn             = var.tfe_cert_secret_arn
  tfe_privkey_secret_arn          = var.tfe_privkey_secret_arn
  ca_bundle_secret_arn            = var.ca_bundle_secret_arn
  tfe_install_secrets_arn         = var.tfe_install_secrets_arn
  console_password                = var.console_password
  enc_password                    = var.enc_password
  log_forwarding_enabled          = var.log_forwarding_enabled
  cloudwatch_log_group_name       = var.cloudwatch_log_group_name

  vpc_id                  = var.vpc_id
  lb_subnet_ids           = var.lb_subnet_ids
  ec2_subnet_ids          = var.ec2_subnet_ids
  rds_subnet_ids          = var.rds_subnet_ids
  ingress_cidr_443_allow  = var.ingress_cidr_443_allow
  ingress_cidr_8800_allow = var.ingress_cidr_8800_allow
  ingress_cidr_22_allow   = var.ingress_cidr_22_allow
  load_balancer_type      = var.load_balancer_type
  load_balancer_scheme    = var.load_balancer_scheme
  route53_hosted_zone_tfe = var.route53_hosted_zone_tfe
  create_tfe_alias_record = var.create_tfe_alias_record
  hairpin_addressing      = var.hairpin_addressing

  kms_key_arn = var.kms_key_arn

  asg_instance_count = var.asg_instance_count
  asg_max_size       = var.asg_max_size
  os_distro          = var.os_distro
  ami_id             = var.ami_id
  encrypt_ebs        = var.encrypt_ebs
  ssh_key_pair       = var.ssh_key_pair

  rds_password            = var.rds_password
  rds_multi_az            = var.rds_multi_az
  rds_skip_final_snapshot = var.rds_skip_final_snapshot

  enable_active_active             = var.enable_active_active
  redis_subnet_ids                 = var.redis_subnet_ids
  redis_password                   = var.redis_password
  redis_at_rest_encryption_enabled = var.redis_at_rest_encryption_enabled
}
