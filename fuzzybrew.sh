#!/usr/bin/env bash

# fuzzybrew.sh

VERSION="1.1.0"

fuzzybrew() {
  local query="$1"
  local selected_packages
  selected_packages=$(
    # Search all packages, evaluate all formulae, and display descriptions
    brew search --eval-all --desc "" | \
    # Remove lines starting with "==>"
    sed -e '/^==>/d' | \
    # Display the list in fzf for fuzzy search
    # Search only by package name
    fzf --multi --ansi --query "$query" \
      --delimiter=': ' \
      --nth=1 \
      --header 'Press CTRL-C to quit, ENTER to install, SHIFT-TAB to select multiple' \
      --preview 'HOMEBREW_COLOR=1 brew info {1}' \
      --preview-window=right:60%:wrap
  )

  if [[ -n $selected_packages ]]; then
    echo "Running: brew install"
    # Install each selected package
    echo "$selected_packages" | cut -f1 -d':' | while read -r package; do
      echo "Installing $package"
      brew install "$package"
    done
  else
    echo "No packages selected."
  fi
}


if [[ "$1" == "--version" ]]; then
  echo "fuzzybrew version $VERSION"
  exit 0
fi

fuzzybrew "$@"
