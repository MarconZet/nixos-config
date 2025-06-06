{
  config,
  pkgs,
  inputs,
  outputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../shared/configuration.nix
    inputs.aagl.nixosModules.default
  ];

  boot.loader.grub = {
    enable = true;
    zfsSupport = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    mirroredBoots = [
      {
        devices = ["nodev"];
        path = "/boot";
      }
    ];
  };

  boot.kernelModules = [
  ];

  hardware.i2c.enable = true;
  hardware.graphics.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };
  services.xserver.videoDrivers = ["nvidia"];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    raopOpenFirewall = true;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    gamescopeSession.enable = true;
  };
  programs.anime-games-launcher.enable = true;
  programs.gamemode.enable = true;

  services.ratbagd.enable = true;

  environment.systemPackages = with pkgs; [
    ffmpeg
    efibootmgr
    ntfs3g
  ];

  fonts.packages = with pkgs; [
    dejavu_fonts
  ];

  networking = {
    hostName = "melchior";
    hostId = "09400c19";
    networkmanager.enable = true;
    nftables.enable = true;
    firewall = {
      enable = true;
    };
  };

  services.udev.packages = [pkgs.via];

  system.stateVersion = "24.05";

  security.sudo.extraRules = [
    {
      users = ["marcin"];
      commands = [
        {
          command = "/run/current-system/sw/bin/efibootmgr";
          options = ["NOPASSWD"];
        }
        {
          command = "/run/current-system/sw/bin/ddcutil";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];
}
