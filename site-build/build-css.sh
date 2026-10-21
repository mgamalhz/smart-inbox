#!/bin/sh
# Rebuild site/style.css after changing classes in site/index.html, then commit both.
# Build sources live here so site/ holds only the files that get published.
cd "$(dirname "$0")" && npx --yes tailwindcss@3.4.19 -c tailwind.config.js -i style.src.css -o ../site/style.css --minify
