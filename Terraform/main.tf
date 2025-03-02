
#---------------- network module ---------------------
module "network" {
    source = "./network"
    vpc_cidr = var.vpc_cidr
    public_subnet1_cidr=var.public_subnet1_cidr
    public_subnet2_cidr=var.public_subnet2_cidr
    private_subnet1_cidr=var.private_subnet1_cidr
    private_subnet2_cidr=var.private_subnet2_cidr
    region=var.region   
}

#---------------- computing module ---------------------
module "computing" {
    source = "./computing"
  source                  = "./computing"
  ami                     = var.ami_id
  instance_type           = var.ec2_instance_typ_id
  region                  = var.region
}