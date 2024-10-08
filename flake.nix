{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    #    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    #    hyprland-plugins.url = "github:hyprwm/hyprland-plugins";

    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    #    hyprland-plugins.inputs.hyprland.follows = "hyprland";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in {
    overlays = import ./overlays {inherit inputs;};

    nixosConfigurations = {
      melchior = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./hosts/melchior/configuration.nix
        ];
      };
      baltazar = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./hosts/baltazar/configuration.nix
        ];
      };
      casper = {};
    };
  };
}
