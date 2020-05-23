resource "aws_key_pair" "aec_key_pair" {
  key_name = local.aws_key_name
  public_key = local.aws_public_key
}