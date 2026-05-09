# ─── DATA SOURCES ───────────────────────
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# ─── SECURITY GROUP ─────────────────────
resource "aws_security_group" "rds_sg" {
  name        = "rds-security-group"
  description = "Allow MySQL Access on port 3306"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ─── SUBNET GROUP ───────────────────────
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = data.aws_subnets.default.ids
}

# ─── RDS INSTANCE ───────────────────────
resource "aws_db_instance" "mysql" {
  identifier        = "my-rds-practice"
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  storage_type      = "gp2"

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  publicly_accessible    = true
  skip_final_snapshot    = true
}