
resource "aws_eip" "nat_ip" {
  vpc = true

  tags = {
    Name = "byry-eip"
  }
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.nat_ip.id
  subnet_id     = aws_subnet.public_subnet1.id

  tags = {
    Name = "nat-gw"
  }
}