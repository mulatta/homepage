{
  perSystem =
    { pkgs, ... }:
    {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          zola
          tailwindcss
          just
        ];
      };
    };
}
