terraform apply should be executed from the starthere folder

Solution
1) the vm flavor and vm image can be controled from the starthere.tf vm_image and vm_flavor variables. In this example, the ami used is for amazon linux free tier. 
2) An admin account is created on all instances using user_data. Creating passwords with the tf resource random_string and adding them as passwords to the admin user. Each instance would have a different password for the admin user is the passwords are outputed. Also, the sshd_config was changed to allow password auth and the ssh deamon restarted
3) VMs are in the same VPC and different subnets (from my personal account). The ping functionality is being added allowing ICMP traffic through the security gateway used by the spawned VMs
4) Running provisioner file to upload script.sh on the ec2 instances, and a provisioner remote-exec after all the EC2 instances are created. 
The logic is: in remote-exec first we get all the public ip's of the created VMs into a temp file
This file is being read into a bash array
The script will get the public ip of the instance it is ran on, and will compare it to the elements in the array. If there is a match and also the compared element matches the last item in the array it will ping the first element in array. Otherwise, it will ping the next element in array.

Unable to find a solution to bring output from remote-exec back into terraform output.
