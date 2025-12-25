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
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };
  services.xserver.videoDrivers = ["nvidia"];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        UserspaceHID = false;
      };
    };
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

  programs.obs-studio = {
    enable = true;

    package = (
      pkgs.obs-studio.override {
        cudaSupport = true;
      }
    );

    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-gstreamer
      obs-vkcapture
    ];
  };

  services.ratbagd.enable = true;

  environment.systemPackages = with pkgs; [
    ffmpeg
    efibootmgr
    ntfs3g
    dotnet-sdk
  ];
  environment.sessionVariables = {
    DOTNET_ROOT = "${pkgs.dotnet-sdk}/share/dotnet";
  };

  fonts.packages = with pkgs; [
    dejavu_fonts
  ];

  networking = {
    hostName = "melchior";
    hostId = "09400c19";
    networkmanager.enable = true;
    nftables.enable = true;
    firewall.enable = true;
    interfaces.enp5s0.wakeOnLan.enable = true;
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
