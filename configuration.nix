{ config, modulesPath, pkgs, lib, ... }:
{
  imports = [ (modulesPath + "/virtualisation/proxmox-lxc.nix") ];
  nix.settings = { sandbox = false; };
  nixpkgs.config.allowUnfree = true;  
  proxmoxLXC = {
    manageNetwork = false;
    privileged = false;
  };
  security.pam.services.sshd.allowNullPassword = true;
  services.fstrim.enable = false; # Let Proxmox host handle fstrim
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
        PermitRootLogin = "yes";
        PasswordAuthentication = true;
        PermitEmptyPasswords = "yes";
    };
  };
  # Cache DNS lookups to improve performance
  services.resolved = {
    extraConfig = ''
      Cache=true
      CacheFromLocalhost=true
    '';
  };

  services.jellyfin = {
	enable = true;
	openFirewall = true;
	user="jellyfin";
  };
  users.users.jellyfin = {
	createHome = true;
	description = "jellyfinuser";
	group = "jellyfin";
	home = "/home/jellyfin";
	uid = 1000;
  };
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  environment.systemPackages = with pkgs; [
	git
	htop
  ];
  system.stateVersion = "25.05";
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia.open = false;
  
  system.autoUpgrade.flake = "github:grendel71/home-nix-infra";
  system.autoUpgrade.enable = true;

  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    version = "535.274.02";


    sha256_64bit = "sha256-O071TwaZHm3/94aN3nl/rZpFH+5o1SZ9+Hyivo5/KTs=";


    sha256_aarch64 = "sha256-PgHcrqGf4E+ttnpho+N8SKsMQxnZn29fffHXGbeAxRw=";


    openSha256 = "sha256-4KRHuTxlU0GT/cWf/j3aR7VqWpOez1ssS8zj/pYytes=";


    settingsSha256 = "sha256-BXQMXKybl9mmsp+Y+ht1RjZqnn/H3hZfyGcKIGurxrI=";


    persistencedSha256 = "sha256-/ZvAsvTjjiM/U3gn0DbxUguC3VvHbopyQ3u6+RYkzKk=";  
  };
}
