data "template_file" "iris_role" {
  template = file("${path.module}/role.json")
}

data "template_file" "iris_policy_base" {
  template = file("${path.module}/policy.json")

  vars = {
    cluster = replace("${var.hostname_prefix}-${var.instance_type}", ".", "")
  }
}


data "template_file" "iris_policy_custom" {
  #template =  var.s3_policy
  template = var.iam_policy_enabled == true ? var.s3_policy : "{}"
}

resource "aws_iam_role" "iris" {
  name               = var.iam_role_name != "" ? var.iam_role_name : replace("${var.hostname_prefix}-${var.instance_type}-Role", ".", "")
  assume_role_policy = data.template_file.iris_role.rendered
}


resource "aws_iam_instance_profile" "iris" {
  name = replace("${var.hostname_prefix}-${var.instance_type}-Profile", ".", "")
  role = aws_iam_role.iris.name
}




resource "aws_iam_policy" "iris_policy_base" {
  name   = replace("${var.hostname_prefix}-${var.instance_type}-Policy", ".", "")
  policy = data.template_file.iris_policy_base.rendered
}

resource "aws_iam_policy" "iris_policy_custom" {
  name   = replace("${var.hostname_prefix}-${var.instance_type}-BucketPolicy", ".", "")
  policy = data.template_file.iris_policy_custom.rendered
}



/*
resource "aws_iam_policy" "iris_combined" {
  name   = replace("${var.hostname_prefix}-${var.instance_type}-IAM-Policy", ".", "")
  policy = data.aws_iam_policy_document.combined.json
}
*/

resource "aws_iam_role_policy_attachment" "iris_base" {
  #policy_arn = aws_iam_policy.iris_combined.arn
  policy_arn = aws_iam_policy.iris_policy_base.arn
  role       = aws_iam_role.iris.name
}

resource "aws_iam_role_policy_attachment" "iris_bucket" {
  #policy_arn = aws_iam_policy.iris_combined.arn
  policy_arn = aws_iam_policy.iris_policy_custom.arn
  role       = aws_iam_role.iris.name
}

/*
data "aws_iam_policy_document" "combined" {
  source_policy_documents = [
    data.template_file.iris_policy_base.rendered,
    data.template_file.iris_policy_custom.rendered
  ]
}
*/