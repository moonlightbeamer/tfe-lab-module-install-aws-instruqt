terraform {
  required_providers {
    aws = "~> 3.64.2"
  }
}

provider "aws" {
  region = "us-west-2"
}

# These are pre-requisites for this config and are automatically configured for Instruqt labs during setup.
data "aws_s3_bucket" "bootstrap_bucket" {
  bucket = "${var.friendly_name_prefix}-bootstrap"
}


data "aws_acm_certificate" "tfe" {
  domain   = "*.training.hashidemos.io"
}


resource "aws_key_pair" "sshkey" {
  key_name   = "lab-ssh-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.11.0"
  name    = "my-vpc"
  cidr    = "10.0.0.0/16"

  # If you change your region be sure to update your provider above ^^^
  azs             = ["us-west-2a", "us-west-2b", "us-west-2c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "random_password" "rds_password" {
  length = 16
  special = false
}


resource "aws_s3_bucket_object" "license" {
  bucket = data.aws_s3_bucket.bootstrap_bucket.id
  key    = "tfe_license.rli"
  source = var.tfe_license_file_path
}

module "tfe" {
  source = "./modules/terraform-aws-tfe"

  # These are created by the terraform code above ^^^`
  ssh_key_pair   = aws_key_pair.sshkey.key_name
  vpc_id         = module.vpc.vpc_id
  lb_subnet_ids  = module.vpc.public_subnets
  ec2_subnet_ids = module.vpc.public_subnets
  rds_subnet_ids = module.vpc.public_subnets

  # These can all be left at their defaults, see variables.tf
  common_tags             = var.common_tags
  console_password        = var.console_password
  enc_password            = var.enc_password
  tfe_release_sequence    = var.tfe_release_sequence
  os_distro               = var.os_distro
  ingress_cidr_443_allow  = var.ingress_cidr_443_allow
  ingress_cidr_8800_allow = var.ingress_cidr_8800_allow
  ingress_cidr_22_allow   = var.ingress_cidr_22_allow
  kms_key_arn             = var.kms_key_arn
  tfe_bootstrap_bucket    = data.aws_s3_bucket.bootstrap_bucket.id
  tfe_license_filepath    = "s3://${data.aws_s3_bucket.bootstrap_bucket.id}/${aws_s3_bucket_object.license.id}"


  rds_password            = random_password.rds_password.result
  rds_skip_final_snapshot = true

  # rds_is_aurora             = true
  # aurora_rds_instance_class = "db.t3.medium"

  tfe_tls_certificate_arn = data.aws_acm_certificate.tfe.arn


  # These should be customized in your terraform.tfvars file
  friendly_name_prefix    = var.friendly_name_prefix
  tfe_hostname            = var.tfe_hostname
  route53_hosted_zone_tfe = var.route53_hosted_zone_name
}

