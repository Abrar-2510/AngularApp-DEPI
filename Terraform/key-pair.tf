



# ---------------- create ssh key using tls_private_key --------------------------

resource "tls_private_key" "my_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "my_ssh_key" {
  key_name   = "my_lab_key"
  public_key = tls_private_key.my_key.public_key_openssh

    # provisioner "local-exec" {
    # redirect the output of private key to a file
    # command = "echo ${tls_private_key.my_key.private_key_pem} > ./my_lab_key.pem" 
   
}

resource "local_file" "ssh_key" {
  filename = "/root/.ssh/pk.pem"
  content = tls_private_key.my_key.private_key_pem
  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command = "chmod 400 /root/.ssh/pk.pem"
  }
}
