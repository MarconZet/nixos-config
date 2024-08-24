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

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.pulseaudio.enable = false;

  #services.xserver = {
  #  enable = true;
  #  displayManager.gdm.enable = true;
  #  desktopManager.gnome.enable = true;
  #};
  programs.hyprland = {
    enable = true;
    #package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    #portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
  };
  environment.variables.NIXOS_OZONE_WL = "1";

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  networking = {
    hostName = "baltazar";
    networkmanager.enable = true;
    nftables.enable = true;
    firewall = {
      enable = true;
    };
  };

  system.stateVersion = "24.05";
}
