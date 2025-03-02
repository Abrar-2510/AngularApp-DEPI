


resource "aws_vpc" "byry-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "byry-vpc"
  }
}


#separate resource just for check

resource "null_resource" "run-command" {
  provisionar "local-exec" {
    command= "date > date.txt"
  }

  } # terraform taint --> destroy then create to provision somewhat resource