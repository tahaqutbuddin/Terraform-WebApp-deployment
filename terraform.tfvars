#terrafor.tfvars is default file name for compilation, if changed then either add 
#.auto.tfvars or pass file name in CLI as a param like -var-file="prod.tfvars"
env_code     = "DevOps-Tutorial"
vpc_cidr     = "10.0.0.0/16"
public_cidr  = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
private_cidr = ["10.0.100.0/24", "10.0.101.0/24", "10.0.102.0/24"]