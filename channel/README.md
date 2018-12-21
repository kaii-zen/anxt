# Channel

This packs a directory into a tar.xz file, following the format expected by `nix-channel`.
It uses the `external` data provider to delegate the work to Nix and hence Nix is required.
The reason I chose to use Nix here is because I was bit too many times in the past by differences between the BSD utils included with macOS and their GNU counterparts. It also saves us the hassle of dealing with temporary files.
If anyone ever wants to use this in a context where Nix might not be available and cannot be installed (i.e., Terraform Enterprise), then they're welcome to open a PR.
