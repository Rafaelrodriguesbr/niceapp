#### Default Region #### 
variable "region" {
  description = "AWS Region"
  default = "us-east-1" //edit here
}

#### SSH public key path #### 
resource "aws_key_pair" "ssh" {
  key_name = "id_rsa"
  public_key = "${file("${var.key_path}")}" //edit here
}
variable "key_path" {
  description = "Public key path"
  default = "id_rsa.pub" //edit here
}

#### Linux AMI type for EC2 machine #### 
variable "ami" {
  description = "AMI"
  default = "ami-8c1be5f6" // Amazon Linux - edit here
}

#### Instance class ####
variable "instance_type" {
  description = "EC2 instance type"
  default = "t2.micro" // free instance - edit here
}

####  Amazon Virtual Private Cloud for the project #### 
variable "vpc_id" {
  description = "vpc-29368153"
  default = "vpc-29368153" //edit here
}

#### cidr to access instance by ssh #### 
variable "ip_ssh" {
  description = "Public_IP"
  default = ["0.0.0.0/0"] //edit here
}

####  criar bucket para logs de acesso ao s3 ####
variable "s3_acess" {
  description = "Bucket Name"
  default = "s3-logs-acess-niceapp"   //edit here
}


####  create bucket for report vulnerability scan ####
variable "s3_report" {
  description = "Bucket Report Vulnerability"
  default = "vulerability-reportniceapp-2019"   //edit here
}

####  create bucket for report Cloud Traill Logs ####
variable "s3_cloudtraill" {
  description = "Bucket traill"
  default = "cloud-traill-niceapp"   //edit here
}

####  Availability Zones ####
variable "azs" {
  description = "Availability Zones"
  default = ["us-east-1a","us-east-1b","us-east-1c"]  //edit here
}

#### AWS Config
variable "bucket_prefix" {
  default = "config"
}

variable "bucket_key_prefix" {
  default = "config"
}

variable "tags" {
  default = {
    "owner"   = "Niceapp"
    "project" = "config"
    "client"  = "Sandbox"
  }
}