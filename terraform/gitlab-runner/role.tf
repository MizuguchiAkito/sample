data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "session_manager_core" {
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  name = "${var.prefix_name}-ec2-role"
  tags = {
    Name = "${var.prefix_name}-ec2-role"
  }
}

resource "aws_iam_role_policy_attachments_exclusive" "session_manager_core" {
  policy_arns = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
  role_name   = aws_iam_role.session_manager_core.name
}

resource "aws_iam_instance_profile" "instance_role" {
  name = "${var.prefix_name}-ec2-instance-profile"
  role = aws_iam_role.session_manager_core.name
}
