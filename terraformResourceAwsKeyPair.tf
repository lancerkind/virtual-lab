resource "aws_key_pair" "aec_key_pair" {
  key_name = "lancer@macattack"
  public_key = file("/Users/lancer/workspace/virtual-lab/privatekey.txt.pub")
}
