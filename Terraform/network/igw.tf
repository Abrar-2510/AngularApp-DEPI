
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.byry-vpc.id

  tags = {
    Name = "igw"
  }
}