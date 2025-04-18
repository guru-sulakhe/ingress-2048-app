variable "instance_type" {
  type        = string
  default     = "t3.micro"
}
variable "vpc_security_group_ids" {
    default = ["sg-0ae3a12e7b7696e53"]
}
variable "subnet_id" {
    default = "subnet-0be035a5a62ef124e"
}