#!/usr/bin/env sh

PATH_LIST=(
  '.clang-format'
  '.config/amethyst/amethyst.yml'
  '.config/ghostty/config'
  '.config/nvim/init.lua'
  '.config/tmux/tmux.conf'
  '.local/bin/,install-fzf'
  '.local/bin/,install-tree-sitter-cli'
  '.vimrc'
)
PRIVATE_REPO="$HOME/dotfiles"

if [[ ! -d $PRIVATE_REPO ]]; then
  echo "$PRIVATE_REPO not found" >&2
  exit 1
fi

for path in "${PATH_LIST[@]}"; do
  if [[ -z $path ]]; then
    continue
  fi

  src="$PRIVATE_REPO/$path"

  if [[ ! -e $src ]]; then
    echo "Missing source path: $src" >&2
    continue
  fi

  mkdir -p "$(dirname "$path")"

  if [[ -d $src ]]; then
    rm -rf "$path"
    cp -R "$src" "$path"
  else
    cp "$src" "$path"
  fi

  echo "Synced: $path"
done
