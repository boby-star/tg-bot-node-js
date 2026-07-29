#!/bin/bash
set -euo pipefail
node --version; npm --version; command -v node; command -v npm; systemctl --version | head -1
[[ $(node -p 'process.versions.node.split(`.`)[0]') == 24 ]] || { echo 'Node.js 24.x required' >&2; exit 1; }
printf 'Resolved node: '; readlink -f "$(command -v node)"
