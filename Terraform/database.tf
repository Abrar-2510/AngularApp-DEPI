# ---------------------- RDS Instance Configuration -----------------------

resource "aws_db_instance" "my_mysql_rds" {
  allocated_storage              = 10
  engine                        = var.db_engine
  engine_version                = var.db_engine_version
  instance_class                = var.db_instance_class
  name                          = var.db_name
  username                      = var.db_username
  password                      = var.db_password
  allow_major_version_upgrade   = true
  availability_zone             = "${var.region}a"
  skip_final_snapshot           = true
  vpc_security_group_ids        = [aws_security_group.rds_security_group.id]
  db_subnet_group_name          = aws_db_subnet_group.rds_subnet_group.name
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = [module.network.private_subnet1_id, module.network.private_subnet2_id]
}

# ---------------------- Elasticache Configuration -----------------------

resource "aws_elasticache_subnet_group" "cache_subnet_group" {
  name       = "my-cache-subnet-group"
  subnet_ids = [module.network.private_subnet1_id, module.network.private_subnet2_id]
}

resource "aws_elasticache_cluster" "my_redis_cluster" {
  cluster_id           = "my-redis-cluster"
  engine               = "redis"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis3.2"
  engine_version       = "3.2.10"
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.cache_subnet_group.name
  security_group_ids   = [aws_security_group.redis_security_group.id]
}
