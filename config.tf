# main.tf

provider "aws" {
  region = var.primary_region
}

provider "aws" {
  alias  = "secondary"
  region = var.secondary_region
}

module "vpc_primary" {
  source               = "./vpc"
  project_name         = var.project_name
  environment          = var.environment
  vpc_cidr             = var.primary_vpc_cidr
  public_subnet_cidrs  = var.primary_public_subnet_cidrs
  private_subnet_cidrs = var.primary_private_subnet_cidrs
  enable_nat_gateway   = var.enable_nat_gateway
}

module "vpc_secondary" {
  source               = "./vpc"
  project_name         = var.project_name
  environment          = "${var.environment}-dr"
  vpc_cidr             = var.secondary_vpc_cidr
  public_subnet_cidrs  = var.secondary_public_subnet_cidrs
  private_subnet_cidrs = var.secondary_private_subnet_cidrs
  enable_nat_gateway   = var.enable_nat_gateway

  providers = {
    aws = aws.secondary
  }
}

module "database" {
  source                 = "./database"
  project_name           = var.project_name
  environment            = var.environment
  primary_region         = var.primary_region
  secondary_region       = var.secondary_region
  vpc_id                 = module.vpc_primary.vpc_id
  vpc_cidr               = var.primary_vpc_cidr
  secondary_vpc_id       = module.vpc_secondary.vpc_id
  secondary_vpc_cidr     = var.secondary_vpc_cidr
  subnet_ids             = module.vpc_primary.private_subnet_ids
  secondary_subnet_ids   = module.vpc_secondary.private_subnet_ids
  db_name                = var.db_name
  db_username            = var.db_username
  db_password            = var.db_password
  db_instance_class      = var.db_instance_class
  db_instance_count      = var.db_instance_count
  db_engine_version      = var.db_engine_version
  db_min_capacity        = var.db_min_capacity
  db_max_capacity        = var.db_max_capacity
  db_auto_pause_seconds  = var.db_auto_pause_seconds
  backup_retention_period = var.backup_retention_period
  preferred_backup_window = var.preferred_backup_window

  providers = {
    aws.secondary = aws.secondary
  }
}