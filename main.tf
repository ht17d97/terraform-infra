data "aws_ami" "rhel" {
  most_recent = true
  owners      = ["309956199498"]
  filter {
    name   = "name"
    values = [var.image_name]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "redhat-vm" {
  ami                    = data.aws_ami.rhel.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.ssh-login.key_name
  subnet_id = aws_subnet.public[1].id
  vpc_security_group_ids = [aws_security_group.allow_ports.id]
  tags = {
    Name = "TechPoc-Himanshu"
  }

#### used to share data to remote server
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("${path.module}/id_rsa")
    host        = self.public_ip
  }
  provisioner "file" {
    source      = "userdata_script.sh"
    destination = "/tmp/userdata_script.sh"
  }
  provisioner "remote-exec" {
    script = "./userdata_script.sh"
  }

}
