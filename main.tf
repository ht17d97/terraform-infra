resource "aws_instance" "this" {
  ami                     = "ami-0c1fe732b5494dc14"
  instance_type           = "t3.micro"
}
