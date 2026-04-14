# Run on bare `just`. Underscore prefix hides from `--list`.
_default:
    @just --list

# Watch tailwind and serve zola locally.
serve:
    #!/usr/bin/env bash
    set -euo pipefail
    pkg=$(nix build --no-link --print-out-paths 'nixpkgs#geist-font')
    mkdir -p site/static/fonts
    for f in Geist-Regular Geist-Medium Geist-SemiBold GeistMono-Regular; do
        ln -sfn "$pkg/share/fonts/opentype/$f.otf" "site/static/fonts/$f.otf"
    done
    cd site
    # One-shot first so zola never races the initial compile on page load.
    tailwindcss -i css/main.css -o static/css/main.css
    tailwindcss -i css/main.css -o static/css/main.css --watch &
    TW=$!
    trap "kill $TW" EXIT
    zola serve

# Remove local dev artifacts.
clean:
    rm -rf site/static/css site/static/fonts site/public result result-*
