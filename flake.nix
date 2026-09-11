{
  description = "NixOS multi-host configuration & personal dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations = {
      # ASUS ROG Flow Z13 (AMD Strix Halo APU, 128GB Unified Memory)
      flow-z13 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/flow-z13
        ];
      };

      # Alias matching current system hostname before first reboot
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/flow-z13
        ];
      };
    };
  };
}
