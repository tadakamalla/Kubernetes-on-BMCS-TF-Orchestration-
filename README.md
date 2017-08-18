# Kubernetes-on-BMCS-TF-Orchestration-

# Software Requirements

To run this you must have installed the Terraform binary (at least 0.9.x) and configured it per instruction.

You must also have installed the Oracle Bare Metal Cloud Terraform provider.

You will also, of course, need access to an Oracle Bare Metal Cloud Service (BMCS) account. If you do not have access, you can request a free trial. To learn more about Oracle BMCS, read the Getting Started guide.

# Environment Requirements

Follow all instructions for installing the Terraform and Oracle Bare Metal Provider executables.

https://github.com/oracle/terraform-provider-baremetal


# Running the Sample

Once you understand the code, have all the software requirements, and have satisfied the environmental requirements you can build your environment.

The first step is to parse all the modules by typing terraform get. This will build out a .terraform directory in your project root. This needs to be done only once.

The next step is to run terraform plan from the command line to generate an execution plan. Examine this plan to see what will be built and that there are no errors.

If you are satisfied, you can build the configuration by typing terraform apply. This will build all of the dependencies and construct an environment to match the project. I have seen some instances where the apply will fail midway through but the resolution is simply to type terraform apply again and the configuration will complete. Remember that terraform is indepotent so you can run apply as many times as you want and Terraform will sync the config for you.

Note that Terraform generates a terraform.tfstate and terraform.tfstate.backup file which manage the state of your environment. These files should not be hand edited.

If you want to tear down your environment, you can do that by running terraform destroy
# Kubernetes-on-BMCS-TF-Orchestration-
