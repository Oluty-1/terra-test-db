# database/variables.tf

variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "environment" {
  description = "The deployment environment"
  type        = string
}

variable "primary_region" {
  description = "The primary AWS region for deployment"
  type        = string
}

variable "secondary_region" {
  description = "The secondary AWS region for disaster recovery"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where the database will be deployed"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block of the VPC where the database will be deployed"
  type        = string
}

variable "secondary_vpc_id" {
  description = "The ID of the secondary VPC for disaster recovery"
  type        = string
}

variable "secondary_vpc_cidr" {
  description = "The CIDR block of the secondary VPC for disaster recovery"
  type        = string
}

variable "subnet_ids" {
  description = "The IDs of the subnets where the database will be deployed"
  type        = list(string)
}

variable "secondary_subnet_ids" {
  description = "The IDs of the subnets in the secondary region for disaster recovery"
  type        = list(string)
}

variable "db_name" {
  description = "The name of the database"
  type        = string
}

variable "db_username" {
  description = "The master username for the database"
  type        = string
}

variable "db_password" {
  description = "The master password for the database"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "The instance class for the database"
  type        = string
}

variable "db_instance_count" {
  description = "The number of database instances"
  type        = number
  default     = 2
}

variable "db_engine_version" {
  description = "The engine version for the Aurora PostgreSQL database"
  type        = string
}

variable "db_min_capacity" {
  description = "The minimum capacity for database autoscaling"
  type        = number
}

variable "db_max_capacity" {
  description = "The maximum capacity for database autoscaling"
  type        = number
}

variable "db_auto_pause_seconds" {
  description = "The number of seconds before the database auto-pauses"
  type        = number
}

variable "backup_retention_period" {
  description = "The number of days to retain backups"
  type        = number
}

variable "preferred_backup_window" {
  description = "The daily time range during which automated backups are created"
  type        = string
}