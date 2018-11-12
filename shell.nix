with import <nixpkgs> {};
mkShell {
  buildInputs = [
    bashInteractive
    terraform
  ];
}
