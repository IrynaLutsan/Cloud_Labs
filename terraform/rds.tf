resource "aws_security_group" "rds_sg" {
  name        = "cloud-labs-rds-sg"
  description = "Allow MySQL traffic from VPC"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "MySQL port"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "cloud-labs-rds-sg"
  }
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "cloud-labs-rds-subnet-group"
  subnet_ids = [aws_subnet.private_1.id, aws_subnet.private_2.id]

  tags = {
    Name = "cloud-labs-rds-subnet-group"
  }
}

resource "aws_db_instance" "default" {
  allocated_storage      = 20
  max_allocated_storage  = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  db_name                = "appdb"
  username               = "dbadmin"
  password               = "SuperSecretPassword123!" # За потреби замініть пароль
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot    = true
  publicly_accessible    = false

  tags = {
    Name = "cloud-labs-mysql"
  }
}

output "rds_endpoint" {
  description = "Хост підключення до RDS"
  value       = aws_db_instance.default.address
}