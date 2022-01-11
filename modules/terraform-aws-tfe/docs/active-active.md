# Active/Active
TFE now supports an Active/Active architecture, whereby more than one EC2 instance can run simultaneously within the Autoscaling Group. This is made possible by provisioning Redis instances (AWS Elasticache Replication Group) as well as a number of additional installation parameters.

## Deployment Steps
1. You must start by deploying and configuring a normal TFE standalone instance per the main [documentation](../README.md#Getting-Started) in this repository. If you already have a standalone TFE instance up and running with at least the Initial Admin User created, proceed to step 2.

2. Add the following input variables to your Terraform configuration:
```hcl
enable_active_active = true
redis_subnet_ids     = ["subnet-00000000000000000", "subnet-11111111111111111", "subnet-22222222222222222"] # private subnet IDs
redis_password       = "MyTfeRedisPasswd123!" # optional password to enable transit encryption with Redis
```

3. `terraform apply` the changes to provision the AWS Elasticache Replication Group and update the AWS Launch Template.

4. During a maintenance window, replace the EC2 instance within the Autoscaling Group so the subsequent instance is built from the latest Launch Template version. Keep the Autoscaling Group instance count at 1 during this time.

5. Validate the TFE instance by logging in and executing at least one Terraform Run on a Workspace.

6. After the TFE instance is successfully validated, you may scale the EC2 instance count from 1 to 2 by modifying the input variable values for `asg_instance_count` and `asg_max_size`. Currently the maximum number of instances supported is 2.

>Note: once the input variable `enable_active_active = true` is applied, the Admin Console on port 8800 will no longer be accessible.
