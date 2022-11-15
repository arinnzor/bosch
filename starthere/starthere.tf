module "ecosser" {
  source                    = "../"
  component_path            = "../../.."
  name                      = "ecosser"
  os_user                   = "ec2-user"
  vpc_id                    = "vpc-8c82aee7"
  subnet_ids                = ["subnet-a83423c3","subnet-559ddf28","subnet-0066374d"]
  vm_image                  = "ami-070b208e993b59cea"
  vm_flavor                 = "t2.micro"
  count_instances           = "2"
  ssh_sgs                   = []
  key_pair                  = "terraform"
  private_ssh_key_file     = "C:\\Users\\cosco\\Desktop\\awsKeys\\terraform.pem"
  custom_tags = {
    "tag1"        = "ecosser1"
    "tag2"        = "ecosser2"
    "tag3"        = "ecosser3"
    "tag4"        = "ecosser4"
  }
}

output "passwords" {
    value = "${module.ecosser.passwords}"
}

output "ips" {
    value = "${module.ecosser.loc}"
}