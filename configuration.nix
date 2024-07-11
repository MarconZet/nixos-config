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

  nixpkgs.config.allowUnfree = true;
  hardware.graphics.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };

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
  services.xserver.videoDrivers = ["nvidia"];
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure console keymap
  console.keyMap = "pl2";

  # Enable CUPS to print documents.
  #services.printing.enable = true;

  # Enable sound with pipewire.
  #sound.enable = true;
  #hardware.pulseaudio.enable = false;
  #security.rtkit.enable = true;
  #services.pipewire = {
  #  enable = true;
  #  alsa.enable = true;
  #  alsa.support32Bit = true;
  #  pulse.enable = true;
  #  #media-session.enable = true;
  #};

  users.users.marcin = {
    isNormalUser = true;
    description = "Marcin";
    extraGroups = ["networkmanager" "wheel" "incus-admin"];
    packages = with pkgs; [
      firefox
    ];
    password = "a";
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC1S1OCIzk9c0gUFnyW9MvHUKywWacSd1eTdCgOKLlZvMd9Ip8Nfq0Q7Sj/YUfOG5cF00JM6t4rbgd7RJUyf2wFrhAfHqHSiwS+zhV6Jums9o4zD/WwtEmPYS2SfkyKnd0MVktoYuQr5uDe02ZpzkYt+8VlDqFsiZL8iQ+8m9H0Bid14BHLxNX2BYU7mwHBTfAE++q4gw4Mx/vFsEuKaBy1xfU1HOIz1kom7Th7taOG2KucSQMqTOH0mlwhAD2irFLm/bvJ7on8oe+vRAHKiGohr/hvfSZeSygRPTGJauKZyzrzqLhxlhwbCEBOC2Xml/dtg4G5cZ/tUqRfvxF3yOa3 marcinzlakowski@MacDrive.local"];
  };
  users.mutableUsers = false;

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {
      "marcin" = import ./home.nix;
    };
  };

  security.sudo.extraRules = [
    {
      users = ["marcin"];
      commands = [
        {
          command = "/run/current-system/sw/bin/nixos-rebuild";
          options = ["NOPASSWD"];
        }
        {
          command = "/run/current-system/sw/bin/nix-collect-garbage";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];

  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    autosuggestions.async = true;
    enableGlobalCompInit = true;
    syntaxHighlighting.enable = true;
    histSize = 10000;
    ohMyZsh.enable = true;
    ohMyZsh.theme = "af-magic";
  };

  programs.java = {
    enable = true;
    package = pkgs.jdk17;
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];

  environment.systemPackages = with pkgs; [
    git
    tree
    alejandra
    wget
    vulkan-loader
    vulkan-validation-layers
    vulkan-tools
    vulkan-tools-lunarg
    vulkan-utility-libraries
    spirv-tools
    vulkan-extension-layer
    spirv-cross
    glslang
  ];
  programs.steam.enable = true;
  programs.vim.defaultEditor = true;
  #virtualisation.incus.enable = true;
  #virtualisation.lxc.lxcfs.enable = true;

  networking.hostId = "09400c19";
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    nftables.enable = true;
    #bridges = {myincusbr0.interfaces = [];};
    #localCommands = ''
    #  ip address add 192.168.55.1/24 dev myincusbr0
    #'';
    firewall = {
      enable = true;
      #extraInputRules = "iifname \"myincusbr0\" accept";
    };
    #nftables.tables."nat".family = "ip";
    #nftables.tables."nat".content = ''
    #  chain postrouting {
    #    type nat hook postrouting priority 0; policy accept;
    #    ip saddr 192.168.55.0/24 ip daddr != 192.168.55.0/24 masquerade
    #  }
    #'';
  };

  #services.dnsmasq = {
  #  enable = true;
  #  settings = {
  #    # upstream DNS servers
  #    server = ["9.9.9.9" "8.8.8.8" "1.1.1.1"];
  #    # sensible behaviours
  #    domain-needed = true;
  #    bogus-priv = true;
  #    no-resolv = true;
  #
  #    # Cache dns queries.
  #    cache-size = 1000;
  #
  #    dhcp-range = ["myincusbr0,192.168.55.50,192.168.55.254,24h"];
  #    interface = "myincusbr0";
  #    dhcp-host = "192.168.55.1";
  #
  #    # local domains
  #    local = "/lan/";
  #    domain = "lan";
  #    expand-hosts = true;
  #
  #    # don't use /etc/hosts as this would advertise surfer as localhost
  #    no-hosts = true;
  #  };
  #};

  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = true;
    "net.ipv4.conf.default.forwarding" = true;
  };

  boot.kernelModules = ["nf_nat_ftp" "br_netfilter" "iptable_filter" "iptable_raw" "iptable_nat"];
  security.apparmor.enable = false;
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  services.openssh.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
