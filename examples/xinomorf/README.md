# Xinomorf/Anxt example

This demonstrates how use the Anxt module from a Nix expression using [Xinomorf](https://github.com/kreisys/xinomorf).

## Prerequisites

- [Nix](https://nixos.org)
- [Xinomorf](https://github.com/kreisys/xinomorf)

## Usage

You'll need to provide an S3 bucket and a prefix, as well as one or more VPC subnet IDs and a security group that allows SSH (if you wish to ssh into the example instance).
The S3 bucket is used for storing the nix expressions in the `nixos/` directory and whenever a change is pushed, a `nixos-rebuild switch` will be run by the SSM agent on the instance.

To launch, run:

```
$ xm plan
$ xm apply
```

Then make changes to `nixos/configuration.nix`, apply again and see the magic happens. Have fun!
