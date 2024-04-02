{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
  ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pl_PL.UTF-8";
    LC_IDENTIFICATION = "pl_PL.UTF-8";
    LC_MEASUREMENT = "pl_PL.UTF-8";
    LC_MONETARY = "pl_PL.UTF-8";
    LC_NAME = "pl_PL.UTF-8";
    LC_NUMERIC = "pl_PL.UTF-8";
    LC_PAPER = "pl_PL.UTF-8";
    LC_TELEPHONE = "pl_PL.UTF-8";
    LC_TIME = "pl_PL.UTF-8";
  };

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver = {
    layout = "pl";
    xkbVariant = "";
  };

  # Configure console keymap
  console.keyMap = "pl2";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  users.users.marcin = {
    isNormalUser = true;
    description = "Marcin";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [
      firefox
      vscode
    ];
    password = "dupa";
  };
  users.mutableUsers = false;

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {
      "marcin" = import ./home.nix;
    };
  };

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];

  environment.systemPackages = with pkgs; [
    git
    tree
    alejandra
  ];
  programs.vim.defaultEditor = true;
  virtualisation.incus = {
    enable = true;
  };
  virtualisation.lxc.lxcfs.enable = true;
  virtualisation.vmware.guest.enable = true;

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    nftables.enable = true;
    bridges = {myincbr0.interfaces = [];};
    localCommands = ''
      ip address add 192.168.55.1/24 dev myincbr0
    '';
    firewall = {
      enable = true;
      extraInputRules = "iifname \"myincbr0\" accept";
    };
    nftables.tables."nat".family = "ip";
    nftables.tables."nat".content = ''
      chain postrouting {
        type nat hook postrouting priority 0; policy accept;
        ip saddr 192.168.57.0/24 ip daddr != 192.168.57.0/24 masquerade
      }
    '';
  };

  #networking.firewall.extraCommands = ''
  #  iptables -A INPUT -i mylxdbr0 -m comment --comment "my rule for LXD network mylxdbr0" -j ACCEPT

  #  # These three technically aren't needed, since by default the FORWARD and
  #  # OUTPUT firewalls accept everything everything, but lets keep them in just
  #  # in case.
  #  iptables -A FORWARD -o mylxdbr0 -m comment --comment "my rule for LXD network mylxdbr0" -j ACCEPT
  #  iptables -A FORWARD -i mylxdbr0 -m comment --comment "my rule for LXD network mylxdbr0" -j ACCEPT
  #  iptables -A OUTPUT -o mylxdbr0 -m comment --comment "my rule for LXD network mylxdbr0" -j ACCEPT

  #  iptables -t nat -A POSTROUTING -s 192.168.57.0/24 ! -d 192.168.57.0/24 -m comment --comment "my rule for LXD network mylxdbr0" -j MASQUERADE
  #'';

  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = true;
    "net.ipv4.conf.default.forwarding" = true;
  };

  boot.kernelModules = ["nf_nat_ftp"];
  security.apparmor.enable = true;
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # services.openssh.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
