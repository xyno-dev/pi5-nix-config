# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.kernelPackages = pkgs.linuxPackages_rpi4;

  boot.kernelModules = [ "kvm-arm" ];

  nix.settings.extra-experimental-features = [ "nix-command" "flakes" ];

  # Use the GRUB EFI boot loader.
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  users.extraUsers.root.extraGroups = [ "wheel" "docker" ];

  users.users.zayan = {
    isNormalUser = true;
    home = "/home/zayan";
    description = "Zayan's User";
    extraGroups = [ "wheel" "storage" ];
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
    };
  };

  services.adguardhome = {
    enable = true;
    openFirewall = true;
    port = 3000;
    host = "0.0.0.0";
  };

  services.tailscale.enable = true;

  virtualisation.docker.enable = true;

  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  environment.systemPackages = with pkgs; [
    neovim
    xvfb-run
    sunshine
    python312
    python312Packages.pip
    uv
    portaudio
    esptool
    esphome
    alsa-utils
    usbutils
    openjdk21
    unzip
    wget
    screen
    udiskie
    udisks
    cifs-utils
    git
    gcc
    gnumake
    homepage-dashboard
    distrobox
  ];
  
  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 8123 19132 25565 65525 ];
   networking.firewall.allowedUDPPorts = [ 19132 25565 ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?

}

