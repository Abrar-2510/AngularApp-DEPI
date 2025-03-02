variable "region" {
  type = string
}

variable "ami" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnet1_cidr" {
  type = string
}


variable "public_subnet2_cidr" {
  type = string
}


variable "private_subnet1_cidr" {
  type = string
}

variable "private_subnet2_cidr" {
  type = string
}


variable "ec2_instance_type" {
  type = string
}



variable "engine" {
  type = string
}
variable "engine_version" {
  type = string
}
variable "instance_class" {
  type = string
}

variable "name" {
  type = string
}
variable "username" {
  type = string
}
variable "password" {
  type = string
}
variable "parameter_group_name" {
  type = string
}