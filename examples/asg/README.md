 ASG Example

This demonstrates how to use Anxt to run launch an autoscaling group in EC2 and configuring its `motd` using an SSM parameter.

| File         | Description                                  |
| ---          | ---                                          |
| nix/         | NixOS configs                                |
| asg.tf       | autoscaling group config. mostly boilerplate |
| this.tf      | the module under test (../..)                |
| variables.tf | variable definitions for this config         |

Use as any terraform config:

```
$ terraform init
$ terraform plan
$ terraform apply
```

Note that you will need to provide VPC subnet IDs, an S3 bucket, SSH key, and security groups to use.
