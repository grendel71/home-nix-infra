{ config, modulesPath, pkgs, lib, ... }:
{
  imports = [ 
    (modulesPath + "/virtualisation/proxmox-lxc.nix") 
    ./caddy.nix
  ];
  nix.settings = { sandbox = false; };  
  proxmoxLXC = {
    manageNetwork = true;
    privileged = false;
  };
  nix.settings.experimental-features = [ "nix-command" "flakes"];
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
  system.stateVersion = "25.11";

  services.technitium-dns-server = {
    enable = true;
    openFirewall = true;
    firewallUDPPorts = [
      67
      68
      53
    ];
    firewallTCPPorts = [
      53
      5380

    ];
  };

  services.gitea = {
    enable = true;
    #openFirewall = true;
  };
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 3000 80 443 ];

  };
}