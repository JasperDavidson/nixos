{

   description = "Config flake";

   inputs = {
      nixpkgs = { url = "github:NixOS/nixpkgs/nixos-unstable"; };

      # Home-manager flake
      home-manager = { url = "github:nix-community/home-manager/master"; inputs.nixpkgs.follows = "nixpkgs"; };

      # Hyprland flake
      hyprland = { url = "github:hyprwm/Hyprland"; };

      # Hyprland plugins
      hyprland-plugins = {
         url = "github:hyprwm/hyprland-plugins";
         inputs.hyprland.follows = "hyprland";
      };
   };

   outputs =  {self, nixpkgs, home-manager, ... }@inputs:
   let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
   in {
      nixosConfigurations = {
         orthocenter = lib.nixosSystem {
            specialArgs = { inherit inputs; inherit system; };
            modules = [ ./configuration.nix ];
         };
      };

      homeConfigurations = {
         jasperd = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = { inherit inputs; };
            modules = [ ./home.nix ];
         };
      };
   };
}
