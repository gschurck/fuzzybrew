#!/usr/bin/env bash

# fuzzybrew.sh

fuzzybrew() {
  local query="$1"
  local selected_package
  selected_package=$(
    brew search --eval-all --desc "" | \
    sed 's/:.*//' | \
    fzf --ansi --query "$query" \
      --header 'Press CTRL-C to quit, ENTER to install' \
      --preview 'HOMEBREW_COLOR=1 brew info {1}' \
      --preview-window=right:60%:wrap
  )

  if [[ -n $selected_packages ]]; then
    echo "Running: brew install $selected_package"
    brew install "$selected_package"
  else
    echo "No packages selected."
  fi
}

fuzzybrew "$@"