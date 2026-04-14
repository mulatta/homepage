{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];
  perSystem.treefmt = {
    projectRootFile = "flake.nix";
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
    };
  };
}
