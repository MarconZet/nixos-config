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

  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = true;
    "net.ipv4.conf.default.forwarding" = true;
  };

  boot.kernelModules = ["nf_nat_ftp" "br_netfilter" "iptable_filter" "iptable_raw" "iptable_nat"];

  hardware.graphics.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };
  services.xserver.videoDrivers = ["nvidia"];

  hardware.pulseaudio.enable = false;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };

  programs.hyprland = {
    enable = true;
  };

  environment.variables.NIXOS_OZONE_WL = "1";
  # services.xserver = {
  #   enable = true;
  #   videoDrivers = ["nvidia"];
  #   displayManager.gdm.enable = true;
  #   windowManager.awesome.enable = true;
  #   desktopManager.gnome.enable = true;
  # };

  services.printing.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # jack.enable = true;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  networking = {
    hostName = "melchior";
    hostId = "09400c19";
    networkmanager.enable = true;
    nftables.enable = true;
    firewall = {
      enable = true;
    };
  };

  system.stateVersion = "24.05";
}
