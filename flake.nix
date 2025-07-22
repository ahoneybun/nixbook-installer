{
  description = "Nixbook (and Lite) installation media";
  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixos-hardware.url = "github:nixos/nixos-hardware";
  };
    
  outputs = { self, nixpkgs, nixos-hardware }: {
    nixosConfigurations = {
      nixbook = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({ pkgs, lib, modulesPath, ... }: {
            imports = [ (modulesPath + "/installer/cd-dvd/installation-cd-graphical-calamares-gnome.nix") ];
            # Start of configuration of ISO
            boot.kernelPackages = pkgs.linuxPackages_latest;
            boot.supportedFilesystems = lib.mkForce [ "btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs" ];
            environment.systemPackages = with pkgs; [ nano ];
            services.flatpak.enable = true;
            networking = {
              hostName = "nixbook";
              networkmanager.enable = true;
            };
            services.openssh.enable = true;
            system.stateVersion = "25.05";
          })
        ];
      };
      
      nixbook-lite = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({ pkgs, lib, modulesPath, ... }: {
            imports = [ (modulesPath + "/installer/cd-dvd/installation-cd-graphical-calamares-gnome.nix") ];
            # Start of configuration of ISO
            boot.kernelPackages = pkgs.linuxPackages_latest;
            boot.supportedFilesystems = lib.mkForce [ "btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs" ];
            environment.systemPackages = with pkgs; [ nano ];
            services.flatpak.enable = true;
            networking = {
              hostName = "nixbook-lite";
              networkmanager.enable = true;
            };
            services.openssh.enable = true;
            system.stateVersion = "25.05";
          })
        ];
      };
 
    };
    
    # Systems to build with `nix build`
    packages."x86_64-linux".default = self.nixosConfigurations.nixbook.config.system.build.isoImage;
    packages."x86_64-linux".lite = self.nixosConfigurations.nixbook-lite.config.system.build.isoImage;

  };
}
