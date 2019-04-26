resource "aws_secretsmanager_secret" "secret" {
  description         = "Administrator password for instance ${var.instanceid}"
  kms_key_id          = "${data.aws_kms_key.ssm.id}"
  name                = "${var.secret_name_prefix}${var.instanceid}"
  rotation_lambda_arn = "${var.rotation_lambda_arn}"
  rotation_rules {
    automatically_after_days = "${var.rotation_days}"
  }

  tags { #you cannot change the key instanceid because it is hardcoded in the python code
         instanceid = "${var.instanceid}"
  }
  #policy =
}

data "aws_kms_key" "ssm" {
  key_id = "alias/aws/secretsmanager"
}

resource "aws_secretsmanager_secret_version" "secret" {
  lifecycle {
    ignore_changes = [
      "secret_string"
    ]
  }
  secret_id     = "${aws_secretsmanager_secret.secret.id}"
  secret_string = <<EOF
{
  "Administrator": "fake password will the added at the first rotation",
}
EOF
}
