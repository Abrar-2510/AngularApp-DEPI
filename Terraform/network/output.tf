


output vpc_id {
    value = aws_vpc.byry-vpc.id
    description = "value of vpc_id"
}

output public_subnet1_id {
    value = aws_subnet.public_subnet1.id
    description = "value of public_subnet1_id"
}

output public_subnet2_id {
    value = aws_subnet.public_subnet2.id
    description = "value of public_subnet2_id"
}

output private_subnet1_id {
    value = aws_subnet.private_subnet1.id
    description = "value of private_subnet1_id"
}

output private_subnet2_id {
    value = aws_subnet.private_subnet2.id
    description = "value of private_subnet2_id"
}
