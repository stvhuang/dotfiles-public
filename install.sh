#!/usr/bin/env sh

. ./.profile

info() {
  printf "\033[1;32m[INFO]\033[0m ${1}...\n"
}

warn() {
  printf "\033[1;33m[WARN]\033[0m ${1}...\n"
}

UNAME_S="$(uname -s)"
info "Detected OS: ${UNAME_S}"

# ~/
if [ "${UNAME_S}" = "Darwin" ]; then
  # iCloud Drive
  info "Linking ~/iCloudDrive"
  ICLOUD_PATH="${HOME}/Library/Mobile Documents/com~apple~CloudDocs"
  ICLOUD_HOME="${HOME}/iCloudDrive"
  rm -f "${ICLOUD_HOME}"
  ln -fns "${ICLOUD_PATH}" "${ICLOUD_HOME}"

  # dock
  info 'Configuring Dock'
  # defaults delete com.apple.dock # reset to default
  defaults write com.apple.dock autohide -bool true                # auto-hide dock
  defaults write com.apple.dock autohide-delay -float 0.0          # delay before the dock starts to appear/hide (default is 0.5)
  defaults write com.apple.dock autohide-time-modifier -float 0.1  # speed up the slide-in/slide-out animation (default is 1.0. 0 makes it instant)
  defaults write com.apple.dock largesize -int 30                  # magnification size
  defaults write com.apple.dock launchanim -bool false             # launch animation
  defaults write com.apple.dock magnification -bool true           # magnification
  defaults write com.apple.dock mineffect -string scale            # minimize effect
  defaults write com.apple.dock minimize-to-application -bool true # minimize windows into application icon
  defaults write com.apple.dock orientation -string bottom         # dock position (left, bottom)
  defaults write com.apple.dock show-recents -bool false           # show recent applications
  defaults write com.apple.dock tilesize -int 16                   # size
  killall Dock

  # finder
  info 'Configuring Finder'
  defaults write com.apple.finder FXPreferredViewStyle -string Nlsv # list view
  defaults write com.apple.finder FXRemoveOldTrashItems -bool true  # remove items from Trash after 30 days
  defaults write com.apple.finder NewWindowTarget -string PfHm      # default location for new Finder windows: home directory
  defaults write com.apple.finder ShowPathbar -bool true            # path bar at the bottom of Finder windows
  defaults write com.apple.finder _FXSortFoldersFirst -bool true    # sort folders first
  killall Finder

  # trackpad
  info 'Configuring Trackpad'
  defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true                # tap to click
  defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true # 3-finger drag

  # https://apple.stackexchange.com/a/83923
  info 'Increasing key repeat speed'
  defaults write -g InitialKeyRepeat -int 8
  defaults write -g KeyRepeat -int 2
fi

HOME_DFS='
.bash_profile
.bashrc
.clang-format
.env
.jupyter
.kaggle
.mkshrc
.pg_format
.prettierrc
.profile
.pypirc
.shrc
.swift-format
.vimrc
'
for DF in ${HOME_DFS}; do
  info "Linking ~/${DF}"
  rm -rf "${HOME}/${DF}"
  ln -fns "${PWD}/${DF}" "${HOME}/${DF}"
done

# ~/.config
mkdir -pv "${XDG_CONFIG_HOME}"
for DF in "${PWD}/.config/"*; do
  DF_NAME="$(basename "${DF}")"
  info "Linking ~/.config/${DF_NAME}"
  rm -rf "${XDG_CONFIG_HOME}/${DF_NAME}"
  ln -fns "${DF}" "${XDG_CONFIG_HOME}/${DF_NAME}"
done

# ~/.local/bin
mkdir -pv "${HOME}/.local/bin"
for DF in "${PWD}/.local/bin/"*; do
  DF_NAME="$(basename "${DF}")"
  info "Linking ~/.local/bin/${DF_NAME}"
  rm -rf "${HOME}/.local/bin/${DF_NAME}"
  ln -fns "${DF}" "${HOME}/.local/bin/${DF_NAME}"
done

# ~/.ssh
mkdir -pv "${HOME}/.ssh"
for DF in "${PWD}/.ssh/"*; do
  DF_NAME="$(basename "${DF}")"
  info "Linking ~/.ssh/${DF_NAME}"
  rm -rf "${HOME}/.ssh/${DF_NAME}"
  ln -fns "${DF}" "${HOME}/.ssh/${DF_NAME}"
done
if [ ! -f "${HOME}/.ssh/id_ed25519" ] && [ ! -f "${HOME}/.ssh/id_ed25519.pub" ]; then
  info "Generating SSH key"
  ssh-keygen -t ed25519 -f ${HOME}/.ssh/id_ed25519 -N "" -C "${USER}@${HOSTNAME}@$(date +%Y-%m-%d)"
fi
chmod 400 ${HOME}/.ssh/id_*
