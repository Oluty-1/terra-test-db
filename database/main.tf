# database/main.tf

resource "aws_rds_cluster" "aurora" {
  cluster_identifier      = "${var.project_name}-${var.environment}-aurora-cluster"
  engine                  = "aurora-mysql"
  engine_version          = "var.db_engine_version"
  availability_zones      = data.aws_availability_zones.available.names
  database_name           = var.db_name
  master_username         = var.db_username
  master_password         = var.db_password
  backup_retention_period = var.backup_retention_period
  preferred_backup_window = var.preferred_backup_window
  vpc_security_group_ids  = [aws_security_group.db_sg.id]
  db_subnet_group_name    = aws_db_subnet_group.aurora.name
  skip_final_snapshot     = true

  enable_http_endpoint = true  # Enables Data API

  scaling_configuration {
    auto_pause               = true
    max_capacity             = var.db_max_capacity
    min_capacity             = var.db_min_capacity
    seconds_until_auto_pause = var.db_auto_pause_seconds
    timeout_action           = "ForceApplyCapacityChange"
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-aurora-cluster"
    Environment = var.environment
  }
}

resource "aws_rds_cluster_instance" "aurora_instances" {
  count               = var.db_instance_count
  identifier          = "${var.project_name}-${var.environment}-aurora-instance-${count.index + 1}"
  cluster_identifier  = aws_rds_cluster.aurora.id
  instance_class      = "db.t3.micro"  # Changed to t3.micro
  engine              = aws_rds_cluster.aurora.engine
  engine_version      = aws_rds_cluster.aurora.engine_version
  publicly_accessible = false

  tags = {
    Name        = "${var.project_name}-${var.environment}-aurora-instance-${count.index + 1}"
    Environment = var.environment
  }
}

resource "aws_db_subnet_group" "aurora" {
  name       = "${var.project_name}-${var.environment}-aurora-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name        = "${var.project_name}-${var.environment}-aurora-subnet-group"
    Environment = var.environment
  }
}

resource "aws_security_group" "db_sg" {
  name        = "${var.project_name}-${var.environment}-aurora-sg"
  description = "Security group for Aurora cluster"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow MySQL traffic from VPC"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-aurora-sg"
    Environment = var.environment
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}
