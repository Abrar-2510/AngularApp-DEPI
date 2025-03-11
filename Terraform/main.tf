#---------------- network module ---------------------
module "network" {
  source = "./network"
}



#---------------- computing module ---------------------
module "computing" {
  source             = "./computing"
  vpc_id             = module.network.vpc_id
  alb_sg_id          = module.network.alb_sg_id
  private_subnet1_id = module.network.private_subnet1_id
  tg_http_arn        = module.network.tg_http_arn
}


#---------------- ECR module ---------------------

module "storage" {
  source = "./storage"
}
