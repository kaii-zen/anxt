#! /usr/bin/env nix-shell
#! nix-shell -i bats -p bats

@test "can ssh" {
  true
}

@test "can sudo" {
  sudo true
}

@test "private key installed" {
  sudo test -f /run/keys/private_key
}

# vim: ft=bats
