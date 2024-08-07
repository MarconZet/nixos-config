{
  config,
  pkgs,
  inputs,
  outputs,
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

  boot.initrd.network.ssh = {
    enable = true;
    authorizedKeys = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC1S1OCIzk9c0gUFnyW9MvHUKywWacSd1eTdCgOKLlZvMd9Ip8Nfq0Q7Sj/YUfOG5cF00JM6t4rbgd7RJUyf2wFrhAfHqHSiwS+zhV6Jums9o4zD/WwtEmPYS2SfkyKnd0MVktoYuQr5uDe02ZpzkYt+8VlDqFsiZL8iQ+8m9H0Bid14BHLxNX2BYU7mwHBTfAE++q4gw4Mx/vFsEuKaBy1xfU1HOIz1kom7Th7taOG2KucSQMqTOH0mlwhAD2irFLm/bvJ7on8oe+vRAHKiGohr/hvfSZeSygRPTGJauKZyzrzqLhxlhwbCEBOC2Xml/dtg4G5cZ/tUqRfvxF3yOa3 marcinzlakowski@MacDrive.local"];
  };
  nixpkgs = {
    overlays = [outputs.overlays.modifications];

    config = {
      allowUnfree = true;
      allowUnfreePredicate = _:true;
    };
  };
  hardware.graphics.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };

  time = {
    timeZone = "Europe/Warsaw";
    hardwareClockInLocalTime = true;
  };

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

  services.xserver = {
    enable = true;
    videoDrivers = ["nvidia"];
    displayManager.gdm.enable = true;
    windowManager.awesome.enable = true;
    desktopManager.gnome.enable = true;
  };

  #  programs.hyprland = {
  #    enable = true;
  #    xwayland.enable = true;
  #  };

  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };

  console.keyMap = "pl2";

  services.printing.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  hardware.pulseaudio.enable = false;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  users.users.marcin = {
    isNormalUser = true;
    description = "Marcin";
    extraGroups = ["networkmanager" "wheel" "incus-admin"];
    packages = with pkgs; [
      firefox
      rpcs3
      vulkan-loader
      vulkan-validation-layers
      vulkan-tools
      vulkan-tools-lunarg
      vulkan-utility-libraries
      spirv-tools
      vulkan-extension-layer
      spirv-cross
      glslang
      teamspeak_client
      jetbrains.idea-ultimate
    ];
    password = "a";
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC1S1OCIzk9c0gUFnyW9MvHUKywWacSd1eTdCgOKLlZvMd9Ip8Nfq0Q7Sj/YUfOG5cF00JM6t4rbgd7RJUyf2wFrhAfHqHSiwS+zhV6Jums9o4zD/WwtEmPYS2SfkyKnd0MVktoYuQr5uDe02ZpzkYt+8VlDqFsiZL8iQ+8m9H0Bid14BHLxNX2BYU7mwHBTfAE++q4gw4Mx/vFsEuKaBy1xfU1HOIz1kom7Th7taOG2KucSQMqTOH0mlwhAD2irFLm/bvJ7on8oe+vRAHKiGohr/hvfSZeSygRPTGJauKZyzrzqLhxlhwbCEBOC2Xml/dtg4G5cZ/tUqRfvxF3yOa3 marcinzlakowski@MacDrive.local"];
  };
  users.mutableUsers = false;

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
    shellAliases = {
      nrs = "~/nixos/home/scripts/rebuild.sh";
      rw = "~/nixos/home/scripts/boot_to_windows.sh";
    };
  };

  programs.java = {
    enable = true;
    package = pkgs.jdk17;
  };

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    warn-dirty = false;
  };

  environment.systemPackages = with pkgs; [
    git
    tree
    alejandra
    wget
    efibootmgr
    rpcs3
  ];
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  programs.vim.defaultEditor = true;

  networking.hostId = "09400c19";
  networking = {
    hostName = "melchior";
    networkmanager.enable = true;
    nftables.enable = true;
    firewall = {
      enable = true;
    };
  };

  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = true;
    "net.ipv4.conf.default.forwarding" = true;
  };

  boot.kernelModules = ["nf_nat_ftp" "br_netfilter" "iptable_filter" "iptable_raw" "iptable_nat"];
  security.apparmor.enable = true;
  security.polkit.enable = true;
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  system.stateVersion = "24.05";
}
