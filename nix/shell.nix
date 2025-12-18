{ forEachSupportedSystem, nixvim, ... }:
forEachSupportedSystem (
  {
    pkgs,
    system,
    self,
  }:
  {
    default = pkgs.mkShell {
      packages =
        with pkgs;

        let
          nvim = nixvim.packages.${system}.default.extend {
            plugins.lsp.servers.arduino_language_server = {
              enable = true;
              cmd = [
                "arduino-language-server"
                "-clangd=${pkgs.clang-tools}/bin/clangd"
                "-cli=${self.packages."x86_64-linux".arduino-cli}/bin/arduino-cli"
                "-cli-config=arduino-cli.yaml"
                "-fqbn=arduino:avr:uno"
              ];

              # This disables semanticTokensProvider when the LSP server attaches
              extraOptions = {
                on_attach.__raw = ''
                  function(client, bufnr)
                  client.server_capabilities.semanticTokensProvider = nil
                  end
                '';
              };
            };
          };

        in
        [
          git
          fastfetch
          onefetch
          libclang
          clang-tools
          usbutils
          self.packages."x86_64-linux".arduino-cli
          nvim
        ];
    };
  }
)
