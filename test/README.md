| File         | Description                                  |
| ---          | ---                                          |
| nixos/       | NixOS configs                                |
| asg.tf       | autoscaling group config. mostly boilerplate |
| this.tf      | the module under test (../)                  |
| variables.tf | variable definitions for this config         |

Use as any terraform config:

```
$ terraform init
$ terraform plan
$ terraform apply
```
