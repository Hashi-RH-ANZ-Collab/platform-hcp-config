data "tfe_outputs" "project" {
  organization = var.tfe_organization_name
  workspace = "platform-hcp-project"
}


locals {
  deployment_id = lower("${var.deployment_name}-${random_string.suffix.result}")
}

resource "random_string" "suffix" {
  length  = 4
  special = false
}

# module "hcp-hvn" {
#   source = "./modules/hcp"

#   region                     = var.aws_region
#   deployment_id              = local.deployment_id
#   cidr                       = var.hcp_hvn_cidr
#   aws_vpc_cidr               = var.aws_vpc_cidr
#   aws_tgw_id                 = module.infra-aws.tgw_id
#   aws_ram_resource_share_arn = module.infra-aws.ram_resource_share_arn
# }

# module "infra-aws" {
#   source  = "./modules/aws"
  
#   region                      = var.aws_region
#   deployment_id               = local.deployment_id
#   vpc_cidr                    = var.aws_vpc_cidr
#   hcp_hvn_provider_account_id = module.hcp-hvn.provider_account_id
#   hcp_hvn_cidr                = var.hcp_hvn_cidr
# }

resource "hcp_hvn" "hvn" {
  hvn_id         = local.deployment_id
  cloud_provider = "aws"
  region         = var.aws_region
  cidr_block     = var.hcp_hvn_cidr
}

module "vault-hcp" {
  source = "./modules/vault"

  deployment_name = var.deployment_name
  hvn_id          = hcp_hvn.hvn.hvn_id
  tier            = var.hcp_vault_tier
}

