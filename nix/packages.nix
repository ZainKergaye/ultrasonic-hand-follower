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
rec {
  arduino-cli = pkgs.wrapArduinoCLI {
    libraries = with pkgs.arduinoLibraries; [
      (arduino-nix.latestVersion ADS1X15)
      (arduino-nix.latestVersion Ethernet_Generic)
      (arduino-nix.latestVersion SCL3300)
      (arduino-nix.latestVersion TMCStepper)
      (arduino-nix.latestVersion pkgs.arduinoLibraries."Adafruit PWM Servo Driver Library")
      (arduino-nix.latestVersion Servo)
      (arduino-nix.latestVersion Ultrasonic)
    ];

    packages = with pkgs.arduinoPackages; [
      platforms.arduino.avr."1.6.23"
      # platforms.rp2040.rp2040."2.3.3"
      # platforms.esp32.esp32."2.0.14"
    ];

  };

  arduino-program = pkgs.stdenv.mkDerivation {
    name = "main";
    src = ../main;
    phases = [
      "copyPhase"
			"scriptPhase"
      "compilePhase"
    ];
    copyPhase = ''
      mkdir -p $out/main
      cp $src/* $out/main/
    '';
		scriptPhase = '' 
			# Create upload script
      cat > $out/upload.sh <<EOF
#!/bin/sh
# Upload the Arduino program to the device
# Ensure the port is correct before running
${arduino-cli}/bin/arduino-cli upload --fqbn=arduino:avr:uno --port /dev/ttyACM0 -i $out/main.ino.hex
EOF

      chmod +rwx $out/upload.sh

		'';
    compilePhase = ''
      cd $out
      ${arduino-cli}/bin/arduino-cli compile main -b arduino:avr:uno --build-path .
    '';
  };
}
