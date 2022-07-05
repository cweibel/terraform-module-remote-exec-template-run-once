# terraform-module-remote-exec-template-run-once
Terraform module to render a template, scp it to a bastion and execute the script only once.

This is basically the same thing as `terraform-module-remote-exec-template-run` but without the UUID trigger


Inputs - Required:

 - `template_name` - Relative path and file name to the template file to render
 - `template_vars` - Map of variables which will be substituted into the template
 - `rendered_file_name` - Name of the rendered template file which will be copied onto the vm
 - `host` -  IP address or DNS resolveable hostname to the bastion/taget vm
 - `ssh_private_key` - SSH Private Key File


Inputs - Optional: 

 - `bastion_user_name` - default = "ubuntu", Name of the user on the bastion/target vm to be used for ssh
 - `rendered_file_destination` - default = "/home/ubuntu", Absolute folder of where to copy the rendered file to

Outputs:

 - `rendered_file_contents` - Outputs the contents of the rendered file
 - `rendered_file_location` - Path to the folder and rendered file name


Example Usage:

```hcl
module "stuff" {
    source                   = "github.com/cweibel/terraform-module-remote-exec-template-run-once.git?ref=0.0.1"

    template_name            = "templates/configure-mgmt-bosh-rds.tpl"
    template_vars            = {
                                  pickles = "mypickles"
                               }
    rendered_file_name       = "hijason.sh"
    host                     = module.bastion.box-bastion-public
    ssh_private_key          = file(var.aws_key_file)

}

output "stuff" {value = module.stuff.rendered_file_contents}
```