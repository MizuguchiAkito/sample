resource "aws_s3_bucket" "deployment" {
  bucket = "${var.prefix_name}-deployment-bucket-${var.environment}"

  tags = {
    "Name" = "${var.prefix_name}-deployment-bucket-${var.environment}"
  }
}
