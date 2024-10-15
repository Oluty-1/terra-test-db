# vars.tf

variable "project_name" {
  description = "The name of the project"
  default     = "terra"
}

variable "environment" {
  description = "The deployment environment"
  default     = "dev"
}

variable "primary_region" {
  description = "The primary AWS region for deployment"
  default     = "us-west-1"
}

variable "ZONE1" {
  description = "The AWS region"
  default     = "us-west-1a"
}

variable "ZONE2" {
  description = "The AWS region"
  default     = "us-west-1b"
}

variable "secondary_region" {
  description = "The secondary AWS region for disaster recovery"
  default     = "us-west-2"
}

# VPC variables
variable "primary_vpc_cidr" {
  description = "The CIDR block for the primary VPC"
  default     = "10.0.0.0/16"
}

variable "secondary_vpc_cidr" {
  description = "The CIDR block for the secondary VPC"
  default     = "10.1.0.0/16"
}

# Database variables
variable "db_name" {
  description = "The name of the database"
  default     = "terradb"
}

variable "db_username" {
  description = "The master username for the database"
  default     = "admin"
}

variable "db_password" {
  description = "The master password for the database"
  sensitive   = true
}

variable "db_instance_class" {
  description = "The instance class for the database"
  default     = "db.t3.micro"
}

variable "db_engine_version" {
  description = "The engine version for the Aurora MySQL database"
  type        = string
  default     = "5.7.mysql_aurora.2.10.2"
}

# Autoscaling variables
variable "db_min_capacity" {
  description = "The minimum capacity for database autoscaling"
  type        = number
  default     = 2
}

variable "db_max_capacity" {
  description = "The maximum capacity for database autoscaling"
  type        = number
  default     = 8
}

variable "db_auto_pause_seconds" {
  description = "The number of seconds before the database auto-pauses"
  type        = number
  default     = 300
}

# Backup variables
variable "backup_retention_period" {
  description = "The number of days to retain backups"
  type        = number
  default     = 7
}

variable "preferred_backup_window" {
  description = "The daily time range during which automated backups are created"
  type        = string
  default     = "07:00-09:00"
}

# Secondary VPC variables

variable "secondary_public_subnet_cidrs" {
  description = "List of CIDR blocks for secondary public subnets"
  type        = list(string)
  default     = ["10.1.1.0/24", "10.1.2.0/24"]
}

variable "secondary_private_subnet_cidrs" {
  description = "List of CIDR blocks for secondary private subnets"
  type        = list(string)
  default     = ["10.1.10.0/24", "10.1.20.0/24"]
}

variable "enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  type        = bool
  default     = true
}
