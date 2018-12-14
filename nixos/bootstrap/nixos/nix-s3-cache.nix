{
  # Use the cache.nixos.org S3 bucket directly, rather than going
  # through Cloudfront, since same-region EC2<->S3 traffic is
  # free. Also it avoids caching of negative lookups by
  # Cloudfront.
  nix.binaryCaches = [ https://nix-cache.s3.amazonaws.com ];
}
