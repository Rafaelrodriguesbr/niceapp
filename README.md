
# NiceAPP

### Description

- Publish WEB application and API
- Create AUTOSCALE and LOADBALANCE in 2 instances
- Make an application vulnerability scanner to validate if there are any vulnerabilities in these images
- Save the vulnerability scanner report in S3
- Enable CLOUDTRAILL and log file validation
- Enable AWS CONFIG service
- Centralize vulnerability report access logs and CLOUDTRAILL logs in another bucket


### Requirements
- [Terraform](https://www.terraform.io/downloads.html)
- [AWS Account](https://aws.amazon.com/)
- [Amazon EC2 Key Pairs](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html)

### Repository Structure
![Captura de tela de 2019-12-01 21-04-05](https://user-images.githubusercontent.com/57097868/69922884-d29a8c00-147e-11ea-897e-2c63a46fd728.png)

### Running the project

- Clone the repository
```
git clone https://github.com/Rafaelrodriguesbr/niceapp/

```
- Edit the variables in the file`variables.tf` 
     -   region
     -   aws_key_pair
     -   key_path
     -   vpc_id
     -   ip_ssh


- Execute terraform

```
terraform init
terraform plan
terraform apply

```

### Removing the entire environment

To remove all created machines and settings, simply execute the command

`terraform destroy`


