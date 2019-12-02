#### creating croudtraill with logs in s3 ####
data "aws_caller_identity" "current" {}

resource "aws_cloudtrail" "traill" {
  name                          = "traill_nice-app"
  s3_bucket_name                = "${aws_s3_bucket.traill.id}"
  s3_key_prefix                 = "prefix"
  include_global_service_events = true
  enable_log_file_validation = true
  event_selector {
    read_write_type = "All"
    include_management_events = true
  }

}

#### AWS config
# -----------------------------------------------------------
# set up a role for the Configuration Recorder to use
# -----------------------------------------------------------
resource "aws_iam_role" "config" {
  name = "config-example"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "config.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "config" {
  role       = "${aws_iam_role.config.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRole"
}

# -----------------------------------------------------------
# set up a bucket for the Configuration Recorder to write to
# -----------------------------------------------------------
resource "aws_s3_bucket" "config" {
  bucket_prefix = "${var.bucket_prefix}"
  acl           = "private"
  region        = "${var.region}"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = false  #edit for production
  }

  lifecycle_rule {
    enabled = true
    prefix  = "${var.bucket_key_prefix}/"

    expiration {
      days = 365
    }

    noncurrent_version_expiration {
      days = 365
    }
  }

  tags = "${merge(map("Name","Config Bucket"), var.tags)}"
}

resource "aws_s3_bucket_policy" "config_bucket_policy" {
  bucket = "${aws_s3_bucket.config.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Allow bucket ACL check",
      "Effect": "Allow",
      "Principal": {
        "Service": [
         "config.amazonaws.com"
        ]
      },
      "Action": "s3:GetBucketAcl",
      "Resource": "${aws_s3_bucket.config.arn}",
      "Condition": {
        "Bool": {
          "aws:SecureTransport": "true"
        }
      }
    },
    {
      "Sid": "Allow bucket write",
      "Effect": "Allow",
      "Principal": {
        "Service": [
         "config.amazonaws.com"
        ]
      },
      "Action": "s3:PutObject",
      "Resource": "${aws_s3_bucket.config.arn}/${var.bucket_key_prefix}/AWSLogs/Config/*",
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        },
        "Bool": {
          "aws:SecureTransport": "true"
        }
      }
    },
    {
      "Sid": "Require SSL",
      "Effect": "Deny",
      "Principal": {
        "AWS": "*"
      },
      "Action": "s3:*",
      "Resource": "${aws_s3_bucket.config.arn}/*",
      "Condition": {
        "Bool": {
          "aws:SecureTransport": "false"
        }
      }
    }
  ]
}
POLICY
}

# -----------------------------------------------------------
# set up the  Config Recorder
# -----------------------------------------------------------

resource "aws_config_configuration_recorder" "config" {
  name     = "config-example"
  role_arn = "${aws_iam_role.config.arn}"

  recording_group {
    all_supported                 = true
    include_global_resource_types = true
  }
}


resource "aws_config_configuration_recorder_status" "config" {
  name       = "${aws_config_configuration_recorder.config.name}"
  is_enabled = true


}






