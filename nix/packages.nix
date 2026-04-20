{ inputs, lib, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      # inputs.self.lastModifiedDate is "YYYYMMDDhhmmss".
      # Falls back to a fixed epoch when the flake is evaluated from a
      # non-git source (so the build still succeeds with a placeholder).
      raw = inputs.self.lastModifiedDate or "19700101000000";
      lastUpdated = "${lib.substring 0 4 raw}-${lib.substring 4 2 raw}-${lib.substring 6 2 raw}";
    in
    {
      packages.homepage = pkgs.stdenvNoCC.mkDerivation {
        pname = "homepage";
        version = "0.1.0";

        src = pkgs.lib.cleanSourceWith {
          src = ../site;
          filter =
            path: _type:
            let
              base = baseNameOf path;
            in
            base != "public"
            && !(base == "fonts" && builtins.match ".*/static/fonts" path != null)
            && base != ".DS_Store";
        };

        nativeBuildInputs = [
          pkgs.zola
          pkgs.tailwindcss
        ];

        configurePhase = ''
          runHook preConfigure
          mkdir -p static/fonts static/css
          for f in Geist-Regular Geist-Medium Geist-SemiBold GeistMono-Regular; do
            cp -f ${pkgs.geist-font}/share/fonts/opentype/$f.otf static/fonts/$f.otf
          done
          substituteInPlace config.toml \
            --replace-fail 'last_updated = "dev"' 'last_updated = "${lastUpdated}"'
          runHook postConfigure
        '';

        buildPhase = ''
          runHook preBuild
          tailwindcss -i css/main.css -o static/css/main.css --minify
          zola build --output-dir public
          runHook postBuild
        '';

        installPhase = ''
          runHook preInstall
          mkdir -p $out
          cp -r public/. $out/
          runHook postInstall
        '';
      };

    };
}
