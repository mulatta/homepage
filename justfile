# Run on bare `just`. Underscore prefix hides from `--list`.
_default:
    @just --list

# Watch tailwind and serve zola locally.
serve:
    #!/usr/bin/env bash
    set -euo pipefail
    cd site
    tailwindcss -i css/main.css -o static/css/main.css --watch &
    TW=$!
    trap "kill $TW" EXIT
    zola serve
