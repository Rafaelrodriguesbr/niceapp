####  Settings provider #### 
provider "aws" {
    region = "${var.region}"     
}

####  User-Data Script #### 
data "template_file" "bootstrap_ec2" {
 template = "${file("user-data/bootstrap.sh.tpl")}"

}

####  create bucket for s3 log acess #### 
resource "aws_s3_bucket" "bucket_logs" {
  bucket = "${var.s3_acess}"  
  acl    = "log-delivery-write"
  force_destroy = true

}
####  create bucket for report vulnerability scan #### 
resource "aws_s3_bucket" "bucket_report" {
  bucket = "${var.s3_report}"  
  acl    = "log-delivery-write"
  force_destroy = true

  tags = {
    Name        = "Vulnerability_Report"
    Environment = "nice-app"
  }

    logging {
    target_bucket = "${aws_s3_bucket.bucket_logs.id}"
    target_prefix = "log/Vulnerability_Report/"
  }
}

#### Role ec2 >s3 send vulnerability #### 
resource "aws_iam_role" "role-ec2-s3" {
  name = "role-ec2-s3"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
      tag-key = "aws_iam_role"
  }
}

#### Instance Profile -iam-role #### 
resource "aws_iam_instance_profile" "instance-profile" {
  name = "instance-profile-report"
  role = "${aws_iam_role.role-ec2-s3.name}"
}

#### IAM role policy #### 
resource "aws_iam_role_policy" "put_data_s3_policy" {
  name = "put_data_s3_policy"
  role = "${aws_iam_role.role-ec2-s3.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
   {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "s3:PutObject",
            "Resource": "*"
        }
  ]
}
EOF
}

####  Bucket to write cloudtrail logs ####
resource "aws_s3_bucket" "traill" {
  bucket = "${var.s3_cloudtraill}"  
  acl    = "private"
  force_destroy = true

  logging {
    target_bucket = "${aws_s3_bucket.bucket_logs.id}"
    target_prefix = "log/traill-acess-logs/"
  }

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::cloud-traill-niceapp"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
             "Resource": "arn:aws:s3:::${var.s3_cloudtraill}/prefix/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
                "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }

    ]
}
POLICY
}



