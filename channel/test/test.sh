#! /usr/bin/env nix-shell
#! nix-shell -i bats -p bats gnutar

@test "has nixexprs/configuration.nix" {
  tar tf $out_path | grep '^\./nixexprs/configuration.nix$'
}

@test "has binary-cache-url" {
  tar tf $out_path | grep '^\./binary-cache-url$'
}
