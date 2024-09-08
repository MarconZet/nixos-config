{
  config,
  pkgs,
  inputs,
  outputs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.default
  ];

  nixpkgs = {
    overlays = [outputs.overlays.modifications];

    config = {
      allowUnfree = true;
      allowUnfreePredicate = _:true;
    };
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {
      "marcin" = import ../../home/home.nix;
    };
    useGlobalPkgs = true;
    useUserPackages = true;
  };
  fonts.packages = with pkgs; [
    font-awesome
  ];
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

  console.keyMap = "pl2";

  users.users.marcin = {
    isNormalUser = true;
    description = "Marcin";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [
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

  security.apparmor.enable = true;
  security.polkit.enable = true;

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
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  environment.systemPackages = with pkgs; [
    git
    tree
    alejandra
    wget
    efibootmgr
    rclone
    glslang
    htop
  ];

  programs.vim.defaultEditor = true;

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };
}
