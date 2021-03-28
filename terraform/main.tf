locals {
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCm5dXv8DGBDYlKZhszUEBTi75Gv6LHbkUPGZd3sh9LEfOUafbvMiFVW/1+GYH+ExMGFp6i4Atv9X6MF4QWT7YLg9lKhrwOvo8FxW5pWKaCTIqjHLaUFYA2d332iBZtPapTYor8cq94xPHml+ESBYn59w/Q8TZ+Lg6IVCP7gd2FYsgMtz2AfmP6WYo7ROdI++hba+b3kLrEIJplP9Mo8ln/n/BopdSStEP5R3JaZseYMdBTgQMXGixXyeuoeziQhFQO+YDM7x1zVKoVc2LIUpw7PL4YIyEZdx9hxI5DChM+3WGMCiL2b1+RnCvF0Wd8VPFRQkaIB0OrJKITVQ8enQBZ"
  tags       = { Usage = "PA GWLB DEPLOYMENT" }
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "panos" {
  owners = ["679593333241"]
  most_recent      = true
  #name_regex       = "^myami-\\d{3}"

  filter {
    name   = "name"
    values = ["PA-VM-AWS*10.0*"]
  }
}

module "app_stack" {
  source                      = "./app_stack"
  tags                        = local.tags
  availability_zone           = data.aws_availability_zones.available.names[0] #,data.aws_availability_zones.available.names[1],data.aws_availability_zones.available.names[2]]
  vpc_cidr                    = "10.222.0.0/23"
  sec_gwlbe_ob_route_table_id = module.security_stack.sec_gwlbe_ob_route_table_id
  natgw_route_table_id        = module.security_stack.natgw_route_table_id
  gwlbe_service_id            = module.security_stack.gwlbe_service_id
  gwlbe_service_name          = module.security_stack.gwlbe_service_name
  tgw_id                      = module.security_stack.tgw_id
  sec_gwlbe_ew_id             = module.security_stack.sec_gwlbe_ew_id
  sec_tgwa_route_table_id     = module.security_stack.sec_tgwa_route_table_id
  tgw_sec_attach_id           = module.security_stack.tgw_sec_attach_id
  public_key                  = local.public_key
  tgw_sec_route_table_id      = module.security_stack.tgw_sec_route_table_id
  sec_gwlbe_ob_id             = module.security_stack.sec_gwlbe_ob_id
  sec_gwlbe_ew_route_table_id = module.security_stack.sec_gwlbe_ew_route_table_id
}

module "security_stack" {
  source             = "./security_stack"
  tags               = local.tags
  availability_zones = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1], data.aws_availability_zones.available.names[2]]
  transit_gw_id      = module.tgw_stack.tgw_id
  vpc_cidr           = "10.12.0.0/23"
  firewall_ami_id    = data.aws_ami.panos.id
  public_key         = local.public_key
}

module "tgw_stack" {
  source = "./tgw_stack"
  tags   = local.tags
}
