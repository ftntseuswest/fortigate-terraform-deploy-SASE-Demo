// FGTVM-Hub1 instance

resource "aws_network_interface" "eth0" {
  description = "fgtvm-hub1-port1"
  subnet_id   = aws_subnet.publicsubnetaz1wan1.id
}

resource "aws_network_interface" "eth1" {
  description = "fgtvm-hub1-port2"
  subnet_id   = aws_subnet.publicsubnetaz1wan2.id
}

resource "aws_network_interface" "eth2" {
  description       = "fgtvm-hub1-port3"
  subnet_id         = aws_subnet.privatesubnetaz1lan1.id
  source_dest_check = false
}


resource "aws_network_interface_sg_attachment" "publicattachment1" {
  depends_on           = [aws_network_interface.eth0]
  security_group_id    = aws_security_group.public_allow.id
  network_interface_id = aws_network_interface.eth0.id
}

resource "aws_network_interface_sg_attachment" "publicattachment2" {
  depends_on           = [aws_network_interface.eth1]
  security_group_id    = aws_security_group.allow_all.id
  network_interface_id = aws_network_interface.eth1.id
}

resource "aws_network_interface_sg_attachment" "internalattachment" {
  depends_on           = [aws_network_interface.eth2]
  security_group_id    = aws_security_group.allow_all.id
  network_interface_id = aws_network_interface.eth2.id
}

resource "aws_instance" "fgtvm-hub1" {
  ami               = var.license_type == "byol" ? var.fgtvmbyolami[var.region] : var.fgtvmami[var.region]
  instance_type     = var.size
  availability_zone = var.az1
  key_name          = var.keyname
  user_data         = data.template_file.FortiGate.rendered

  root_block_device {
    volume_type = "standard"
    volume_size = "2"
  }

  ebs_block_device {
    device_name = "/dev/sdb"
    volume_size = "30"
    volume_type = "standard"
  }

  network_interface {
    network_interface_id = aws_network_interface.eth0.id
    device_index         = 0
  }

  network_interface {
    network_interface_id = aws_network_interface.eth1.id
    device_index         = 1
  }

  network_interface {
    network_interface_id = aws_network_interface.eth2.id
    device_index         = 2
  }

  tags = {
    Name = "Hub1-FGTVM"
  }
}


data "template_file" "FortiGate" {
  template = "${file("${var.bootstrap-fgtvm}")}"
  vars = {
    type         = "${var.license_type}"
    license_file = "${var.license}"
    adminsport   = "${var.adminsport}"
  }
}

