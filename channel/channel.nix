{ pkgs ? import <nixpkgs> {}, nixexprs, name, binary-cache-url ? "" }:

let inherit (pkgs) lib runCommand; in

runCommand "${name}-channel.tar.xz" {
  src = nixexprs;
} ''
  mkdir channel
  cd channel
  cp -r $src nixexprs
  ${lib.optionalString (binary-cache-url != "") ''
    echo "${binary-cache-url}" > binary-cache-url
  ''}
  tar -cJf $out .
''
