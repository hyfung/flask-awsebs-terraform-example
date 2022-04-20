provider "aws" {
  region = "us-west-1"
}

resource "aws_s3_bucket" "s3_bucket_myflaskapp" {
  bucket = "flask-app-jerry"
  acl = "private"
}

resource "aws_s3_bucket_object" "s3_bucket_myflaskapp_obj" {
    bucket = aws_s3_bucket.s3_bucket_myflaskapp.id
    key = "beanstalk/app.zip"
    source = "app.zip"
}

resource "aws_elastic_beanstalk_application" "beanstalk_myflaskapp" {
  name = "myflaskapp"
  description = "The description of my application"
}

resource "aws_elastic_beanstalk_application_version" "beanstalk_myapp_version" {
  application = aws_elastic_beanstalk_application.beanstalk_myflaskapp.name
  bucket = aws_s3_bucket.s3_bucket_myflaskapp.id
  key = aws_s3_bucket_object.s3_bucket_myflaskapp_obj.id
  name = "myapp-1.0.0"
}

resource "aws_elastic_beanstalk_environment" "beanstalk_myapp_env" {
  name = "myflaskapp-prod"
  application = aws_elastic_beanstalk_application.beanstalk_myflaskapp.name
  solution_stack_name = "64bit Amazon Linux 2 v3.3.12 running Python 3.8 "
  version_label = aws_elastic_beanstalk_application_version.beanstalk_myapp_version.name
 
  setting {
    name = "SERVER_PORT"
    namespace = "aws:elasticbeanstalk:application:environment"
    value = "5000"
  }

  setting {
    namespace = "aws:ec2:instances"
    name = "InstanceTypes"
    value = "t2.micro"
  }

  setting {
   namespace = "aws:autoscaling:launchconfiguration"
   name = "IamInstanceProfile"
   value = "aws-elasticbeanstalk-ec2-role"
  }
}

output "instance_url" {
  value = aws_elastic_beanstalk_environment.beanstalk_myapp_env.endpoint_url
}
