{
  arduino-nix,
  arduino-index,
  nixpkgs,
}:

let
  system = "x86_64-linux";
  overlays = [
    (arduino-nix.overlay)
    (arduino-nix.mkArduinoPackageOverlay (arduino-index + "/index/package_index.json"))
    (arduino-nix.mkArduinoPackageOverlay (arduino-index + "/index/package_rp2040_index.json"))
    (arduino-nix.mkArduinoLibraryOverlay (arduino-index + "/index/library_index.json"))
  ];
  pkgs = import nixpkgs { inherit system overlays; };
in
{
  ${system}.arduino-cli = pkgs.wrapArduinoCLI {
    libraries = with pkgs.arduinoLibraries; [
      (arduino-nix.latestVersion ADS1X15)
      (arduino-nix.latestVersion Ethernet_Generic)
      (arduino-nix.latestVersion SCL3300)
      (arduino-nix.latestVersion TMCStepper)
      (arduino-nix.latestVersion pkgs.arduinoLibraries."Adafruit PWM Servo Driver Library")
    ];

    packages = with pkgs.arduinoPackages; [
      platforms.arduino.avr."1.6.23"
      platforms.rp2040.rp2040."2.3.3"
      platforms.esp32.esp32."2.0.14"
    ];

  };
}
