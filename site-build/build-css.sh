#!/bin/sh
# Rebuild site/style.css after changing classes in site/index.html, then commit both.
# Build sources live here so site/ holds only the files that get published.
# The stylesheet link carries a content hash, so browsers fetch the new file after every
# change instead of keeping a cached copy that no longer matches the HTML.
set -e
cd "$(dirname "$0")"
npx --yes tailwindcss@3.4.19 -c tailwind.config.js -i style.src.css -o ../site/style.css --minify
hash=$(shasum -a 256 ../site/style.css | cut -c1-10)
sed -i.bak -E "s#href=\"/style\.css(\?v=[0-9a-f]+)?\"#href=\"/style.css?v=$hash\"#" ../site/index.html
rm -f ../site/index.html.bak
grep -q "style.css?v=$hash" ../site/index.html || { echo "style.css link not found in index.html" >&2; exit 1; }
echo "site/style.css built (v=$hash)."
