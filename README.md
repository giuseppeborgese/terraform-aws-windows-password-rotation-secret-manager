# AWS Windows Password Rotation with Secret Manager
When you create an EC2 windows the password will remain the same for the whole life of the machine. It can be rotated automatically with this terrafor module. 

This module depends from  https://registry.terraform.io/modules/giuseppeborgese/windows-password-lambda-rotation/aws/0.0.2

Please also read the full guide on https://medium.com/@giuseppeborgese/aws-windows-password-rotation-with-custom-secret-manager-92f95f44aa40

## Prerequisites

* The ec2 machine is already created and needs to have a role with a policy ssm arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM
* The SSM needs to work on the machines if it is not the password is not replaced and the old one with pem key remains, nothing brokes.
* To change a password it is not necessary to know the previous password because SSM runs as a daemon.

## Infrastructure and steps
Using the terraform modules it will be created

* One lambda function for account and region
* For each machine a secret manager record, all the records call the same functions.

### Creations steps:
Create one lambda function for each region you are working on. Using this code

``` hcl
module "windows-password-lambda-rotation" {
  source  = "giuseppeborgese/windows-password-lambda-rotation/aws"
  prefix  = "pep"
}
```
* Before applying the rotation try to run a simple command like this to the machine, to see if ssm commands can run, check the output in the run command history

``` hcl
aws ssm send-command --instance-ids i-xxxxxxxxx --document-name AWS-RunPowerShellScript --parameters commands="dir c:"
``` 

* For each EC2 Windows machine create a new secret manager record and connected to the function using this code

``` hcl
module "windows-password-rotation-secret-manager2019" {
  source  = "giuseppeborgese/windows-password-rotation-secret-manager/aws"
  secret_name_prefix = "vault_"
  instanceid = "i-xxxxxx"
  rotation_lambda_arn = "${module.windows-password-lambda-rotation.lambda_arn}"
}
``` 
* You can rotate the password manually using the rotation button or wait the numbers of days defined
* You can still recover the old password from the web console but it will NOT work
