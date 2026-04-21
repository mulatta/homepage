{ inputs, lib, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];
  perSystem.treefmt = {
    projectRootFile = "flake.nix";
    settings.global.excludes = [
      "flake.lock"
      "*.svg"
      "*.otf"
      "*.ttf"
      "*.pdf"
    ];
    # Treat Tera templates as Jinja2 for djlint; the flag isn't exposed by
    # treefmt-nix's djlint module, so append it via settings override.
    settings.formatter.djlint.options = lib.mkAfter [
      "--profile"
      "jinja"
    ];
    programs = {
      nixfmt.enable = true;
      deadnix.enable = true;
      statix.enable = true;
      keep-sorted.enable = true;
      mdformat = {
        enable = true;
        # Zola content uses TOML frontmatter delimited by `+++`; without
        # mdformat-frontmatter the delimiters get rewritten into thematic
        # breaks, stripping the frontmatter block.
        plugins = ps: [
          ps.mdformat-frontmatter
          ps.mdformat-footnote
        ];
      };
      biome = {
        enable = true;
        # Biome's CSS parser rejects Tailwind at-rules (@tailwind, @apply,
        # @layer). Scope biome to json and js so the tailwind-specific CSS
        # stays untouched.
        includes = [
          "*.json"
          "*.jsonc"
          "*.js"
          "*.ts"
        ];
      };
      djlint = {
        enable = true;
        indent = 2;
        # H031: meta keywords are deprecated for modern SEO.
        # J018: Jinja convention (url_for) doesn't apply — Tera uses get_url().
        ignoreRules = [
          "H031"
          "J018"
        ];
      };
    };
  };
}
