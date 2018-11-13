{ lib, config, ... }:

let cfg = config.anxt; in
with lib; {
  options.anxt = {
    class = mkOption {
      description = "The name of the configuration";
      type = types.string;
    };
    family = mkOption {
      description = "Auto-generated pet name shared by instances created from the same instance of a configuration";
      type = types.string;
    };
  };
}
