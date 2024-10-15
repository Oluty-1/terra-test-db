# database/global_cluster.tf

resource "aws_rds_global_cluster" "global" {
  global_cluster_identifier = "${var.project_name}-${var.environment}-global-aurora-cluster"
  engine                    = "aurora-mysql"
  engine_version            = var.db_engine_version
  database_name             = var.db_name
  storage_encrypted         = true
}

resource "aws_rds_cluster" "secondary" {
  provider                  = aws.secondary
  cluster_identifier        = "${var.project_name}-${var.environment}-aurora-secondary"
  engine                    = aws_rds_global_cluster.global.engine
  engine_version            = aws_rds_global_cluster.global.engine_version
  global_cluster_identifier = aws_rds_global_cluster.global.id
  db_subnet_group_name      = aws_db_subnet_group.aurora_secondary.name
  skip_final_snapshot       = true
  vpc_security_group_ids    = [aws_security_group.db_sg_secondary.id]

  depends_on = [aws_rds_cluster.aurora]

  tags = {
    Name        = "${var.project_name}-${var.environment}-aurora-secondary"
    Environment = "${var.environment}-dr"
  }
}

resource "aws_rds_cluster_instance" "aurora_instances_secondary" {
  provider             = aws.secondary
  count                = var.db_instance_count
  identifier           = "${var.project_name}-${var.environment}-aurora-secondary-instance-${count.index + 1}"
  cluster_identifier   = aws_rds_cluster.secondary.id
  instance_class       = var.db_instance_class
  engine               = aws_rds_cluster.secondary.engine
  engine_version       = aws_rds_cluster.secondary.engine_version
  publicly_accessible  = false
  db_subnet_group_name = aws_db_subnet_group.aurora_secondary.name

  tags = {
    Name        = "${var.project_name}-${var.environment}-aurora-secondary-instance-${count.index + 1}"
    Environment = "${var.environment}-dr"
  }
}

resource "aws_db_subnet_group" "aurora_secondary" {
  provider   = aws.secondary
  name       = "${var.project_name}-${var.environment}-aurora-subnet-group-secondary"
  subnet_ids = var.secondary_subnet_ids

  tags = {
    Name        = "${var.project_name}-${var.environment}-aurora-subnet-group-secondary"
    Environment = "${var.environment}-dr"
  }
}

resource "aws_security_group" "db_sg_secondary" {
  provider    = aws.secondary
  name        = "${var.project_name}-${var.environment}-aurora-sg-secondary"
  description = "Security group for Aurora cluster in secondary region"
  vpc_id      = var.secondary_vpc_id

  ingress {
    description = "Allow MySQL traffic from VPC"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.secondary_vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-aurora-sg-secondary"
    Environment = "${var.environment}-dr"
  }
}