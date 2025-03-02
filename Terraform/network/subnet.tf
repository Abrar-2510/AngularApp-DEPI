


# ----------------- create public subnet  az1 ---------------

resource "aws_subnet" "public_subnet1" {
  vpc_id            = aws_vpc.byry-vpc.id
  cidr_block        = var.public_subnet1_cidr
  availability_zone = "${var.region}a"
  tags = {
    Name = "public_subnet1"
  }
}


# ----------------- create public subnet az2 ---------------

resource "aws_subnet" "public_subnet2" {
  vpc_id            = aws_vpc.byry-vpc.id
  cidr_block        = var.public_subnet2_cidr
  availability_zone = "${var.region}b"
  tags = {
    Name = "public_subnet2"
  }
}

# ----------------- create private subnet  az1 ---------------

resource "aws_subnet" "private_subnet1" {
  vpc_id            = aws_vpc.byry-vpc.id
  cidr_block        = var.private_subnet1_cidr
  availability_zone = "${var.region}a"
  tags = {
    Name = "private_subnet1"
  }
}

# ----------------- create private subnet az2 ---------------

resource "aws_subnet" "iti_private_subnet2" {
  vpc_id            = aws_vpc.byry-vpc.id
  cidr_block        = var.private_subnet2_cidr
  availability_zone = "${var.region}b"
  tags = {
    Name = "private_subnet2"
  }
}