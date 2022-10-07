data "aws_region" "current" {
}

data "aws_caller_identity" "current" {
}

resource "aws_codedeploy_app" "app" {
  name = "${var.project}-${var.name}"
}

# This policy allows to upload application revisions to S3 (if the S3 bucket arn is provided),
# register application revisions and trigger deployments on all deployment groups
# It's basically taken from the AWS documentation here
# http://docs.aws.amazon.com/codedeploy/latest/userguide/auth-and-access-control-iam-identity-based-access-control.html
resource "aws_iam_policy" "deployer_policy" {
  name        = "${var.project}-${var.name}-deployer-policy"
  description = "Policy to create a codedeploy application revision and to deploy it, for application ${aws_codedeploy_app.app.name}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "codedeploy.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
