variable "security_group_name" {
  type        = string
  description = "name of security group"
  default = "bosch-sg"
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC."
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnets ids where to create the AWS instances."
}

variable "vm_image" {
  type        = string
  description = "The name of the AMI to use for the AWS instances."
}

variable "vm_flavor" {
  type        = string
  description = "Instance type for the AWS instances."
  default     = "t2.small"
}

variable "count_instances" {
  type        = string
  description = "The number of bosch instances."
}

variable "custom_tags" {
  type        = map(string)
  description = "Tags to be applied to resources creted by this component."
  default     = {}
}

variable "component_path" {
  type        = string
  description = "The path to the root folder of this component."
}

variable "name" {
  type        = string
  description = "Used as a prefix for resources names."
  default     = "ecosser"
}

variable "ssh_sgs" {
  type        = list(string)
  description = "Security groups allowed to ssh to bosch instances."
}

variable "os_user" {
  type        = string
  description = "User of cloud instances."
  default     = "ec2-user"
}

variable "private_ssh_key_file" {
  type        = string
  description = "Path to SSH Private key file."
}

variable "key_pair" {
  type        = string
  description = "SSH Key pair name on AWS platform."
}

variable "MY_USER_PUBLIC_KEY" {
  type        = string
  description = "SSH public key for user ecosser"
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQChMf1BewWoZmfwCsd3+F8CAaSmOIrYYppIvR2tCjdS3BMDMtt2GTT3uB4SyOG+Ho+bVhAO1/h8v3Uf6p4HVYb3YG2SsOePivnIhP6mjj5w/+Ktn2nN0bn3OQ9FXODcmITPaUF+WDoT2RFIcbFomgAsWuYyyiShkiHFNXERAMq7bKcjtefzmQoUXuPoyyB1FuafhZ3FnEha+aAue9TsZWV5Wb8r6EweoavtXDbI1llM6i5LrYvkdzsFBpj3B4jyeKbrCEwEQTgT20QpUAUXGA32uZ6mAEk2T4ABT+F2agP/DOlAn51vwUQHw7MwWNYS/Pu4C4QEqiJCQ2yL5gIzC4BJ ecosser"
}