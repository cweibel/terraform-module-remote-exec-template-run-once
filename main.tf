
variable template_name                        {} # Relative path and file name to the template file to render
variable template_vars                        {} # Map of variables which will be substituted into the template
variable rendered_file_name                   {} # Name of the rendered template file which will be copied onto the vm
variable host                                 {} # IP address or DNS resolveable hostname to the bastion/taget vm
variable ssh_private_key                      {} # SSH Private Key File              

variable bastion_user_name         {default = "ubuntu"}        # Name of the user on the bastion/target vm to be used for ssh
variable rendered_file_destination {default = "/home/ubuntu"}  # Absolute folder name of where to copy the rendered file to 


data "template_file" "myfile" {
  template = file("./${var.template_name}")
  vars     = var.template_vars
}

resource "null_resource" "configure_bosh_rds" {

  # Copy the script to the bastion
  provisioner "file" {
    content      = "${data.template_file.myfile.rendered}"
    destination  = "${var.rendered_file_destination}/${var.rendered_file_name}"
    connection {
      type        = "ssh"
      user        = var.bastion_user_name
      private_key = var.ssh_private_key
      host        = var.host
    }
  }

  # Run the script on the bastion
  provisioner "remote-exec" {
    inline = [
        "chmod +x ${var.rendered_file_destination}/${var.rendered_file_name}",
        "${var.rendered_file_destination}/${var.rendered_file_name}"
    ]
    connection {
        type        = "ssh"
        user        = var.bastion_user_name
        private_key = var.ssh_private_key
        host        = var.host
    }
  }
}

output "rendered_file_contents"      {value = data.template_file.myfile.rendered }
output "rendered_file_location"      {value = "${var.rendered_file_destination}/${var.rendered_file_name}" }