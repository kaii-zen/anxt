# ANXT

![ANXT](misc/anxt.png)

## What's this?

In a nutshell: this is a Terraform module that leverages various AWS services in order ot facilitate the herding of NixOS instances.

## What's up with the name?

I'm not sure I even remember. Let's just say it stands for **A**WS **N**i**x**OS **T**erraform. The X is thrown in there because I find Angst more relatable than Ant (the creature or the Java build tool) in this context. It is precisely what I feel whenever I have to change anything here 😅😬

## Why not just use NixOps?

While I do think [NixOps](https://nixos.org/nixops) is a great tool, I have a few issues with it:

- It is very much "pet"-oriented. When working at scale, I need cattle. I need autoscaling groups.
- No collaboration out of the box: NixOps keeps its state in a local SQLite database. There's no easy way share it other than requiring everyone to SSH into a remote server to run NixOps operations.
- NixOS closures need to be built on the operator's machine. This sucks for darwin users who need to have a Linux VM chipping at their RAM and battery life.
- NixOS closures need to be pushed to the target instances over the internet. This sucks for digital nomads who are either on a crappy Starbucks wifi or worse, on a cellular connection.

To be fair, it still does have a couple advantages over Terraform/ANXT:

- We get to do everything in the Nix language, which is delightful compared to Terraform HCL. [Xinomorf](https://github.com/kreisys/xinomorf) is my attempt at mitigating that.
- It's not limited to AWS. ANXT is AWS-specific. I imagine it's possible to implement something similar for other cloud providers using their own services. It just so happens that my employer uses AWS.
- Only builds the closure once; in ANXT, the closure is built on every instance; which is theoretically wasteful, but doesn't really have much impact. It can also be mitigated by using a Nix binary cache.
- Tighter feedback loop, since the closure is built locally, we know immediately if it failed to build. With ANXT we just push a tarball with expressions to S3. There's no feedback whatsoever.

## How does it work?

Consider this example:

```terraform
module "this" {
  source        = "github.com/kreisys/anxt"
  display_name  = "ANXT Example"
  nixos_release = "18.09"
  # This must exist and be accessible
  s3_bucket     = "mybucket"
  # S3 prefix under which configs will be stored
  prefix        = "anxtest"
  nixexprs      = "./nix"
}

resource "aws_instance" "this" {
  ami                    = "${module.this.image_id}"
  instance_type          = "t2.micro"
  iam_instance_profile   = "${module.this.iam_instance_profile}"
  user_data              = "${module.this.userdata}"

  # Those must exist as well
  vpc_security_group_ids = ["sg-1234abcd"]
  subnet_id              = "subnet-abcd123"
  key_name               = "my_key"

  # Better to increase the root filesystem size since it's pretty small
  # by default on the NixOS AMI
  root_block_device {
    volume_size = "50"
    volume_type = "gp2"
  }

  # We rely on tags to target relevant instances in CloudWatch rules and SSM operations.
  # The "tags_map" optput contains the tags in the map format expected by the "aws_instance" resource.
  # For autoscaling groups we use the "tags" output which is formatted as an array of { name, value }
  # pairs as expected by the "aws_autoscaling_group" resource.
  tags = "${module.this.tags_map}"
}
```

`./nix` should, at a minimum, contain an empty `nixos/configuration.nix`:

```
$ find nix
nix
nix/nixos
nix/nixos/configuration.nix
$ cat nix/nixos/configuration.nix
{}
$
```

The module just prepares the "plumbing". We can then use its outputs to start either an instance or an autoscaling group (see [examples/asg](examples/asg)).
By "plumbing" I mean that, among other things, it:

- generates a random "pet" name (something like "wonky albatross", "drunken kangaroo", "wasted kitten", etc); this is then used in various places to help segregate/differentiate generations of config
- kebabifies (anxt-example) and CamelCases (ANXTExample) the display name and pet name for use in different contexts
- packs and uploads to S3 both ANXT's own "bootstrap" config and the user's config (whatever's in `./nix` in our case; note that this is packed verbatim and not preprocessed in any way)
- generates userdata to pass to the "aws_instance" (or "aws_launch_configuration") resource
- creates an SSM runCommand document that (among other things) runs `nixos-rebuild switch`
- sets up cloudwatch rules that will trigger above SSM document whenever:
  - the expressions on S3 change (this requires setting up cloudtrail. see [cloudtrail](cloudtrail))
  - an SSM parameter changes under `<prefix>/<config-name>/<pet-name>` (see [test](test) for an example of using SSM parameters)

That's pretty much it. In a nutshell.
Oh, it's also possible to relay secrets through AWS Secrets Manager (see [test](test)).
The [xinomorf](xinomorf) [bits](examples/xinomorf) are experimental and subject to change and breakage.
(Heck; this whole thing is experimental and might murder your kittens so be warned! I do use it in production though 🙃)

## Want!

### Prerequisites

- [Nix](https://nixos.org/nix): it's used to pack the Nix expressions.
- [Terraform](https://terraform.io)

That's it.

### Usage

Consult the examples. I realize that the README might be inaccurate or downright wrong at times but I try to keep the examples working at the very least. If they aren't feel free to hound me in the issues.

## Current limitations

- Different configs can't share SSM parameters or SecretsManager secrets (config channels *can* be shared; see `test/channel.tf`)
- Channels cannot be added/removed after-the-fact on running instances (can be done manually but ew); a new instance must be created.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
