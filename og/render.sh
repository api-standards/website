#!/bin/sh
# Renders og/og.svg to public/og.png. rsvg-convert refuses to load images outside
# the SVG's directory, so inline them as data URIs first.
set -e
cd "$(dirname "$0")"
node -e '
const fs = require("fs"), path = require("path");
const types = { ".png": "image/png", ".svg": "image/svg+xml" };
const svg = fs.readFileSync("og.svg", "utf8").replace(/xlink:href="([^"#][^"]*)"/g, (_, p) =>
  `xlink:href="data:${types[path.extname(p)]};base64,${fs.readFileSync(p).toString("base64")}"`);
process.stdout.write(svg);
' | rsvg-convert -o ../public/og.png
echo "Wrote public/og.png"
