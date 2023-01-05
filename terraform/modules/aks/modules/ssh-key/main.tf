variable "public_ssh_key" {
  description = "The Public SSH Keys used to access the cluster."
  type        = string
  default     = ""
}
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_sensitive_file" "private_key" {
  count    = var.public_ssh_key == "" ? 1 : 0
  content  = tls_private_key.ssh.private_key_pem
  filename = "./private_ssh_key"
}

output "public_ssh_key" {
  description = "The Public SSH Key (only output a generated ssh public key)."
  value       = var.public_ssh_key != "" ? "" : tls_private_key.ssh.public_key_openssh
}