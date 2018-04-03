#!/bin/zsh
# Simple bootstrap script for dotfiles
# We're deploying zsh dotfiles, so expect zsh to be installed.

if ! command -v curl >/dev/null; then
	echo "curl needs to be installed. Really."
	exit 1
fi

if ! command -v git >/dev/null; then
	echo "git is a hard requirement."
	exit 1
fi

# Paths used
BASE_PATH="${XDG_CONFIG_HOME:=$HOME/.config}/vcsh"
HOOKS_PATH="${BASE_PATH}/hooks-enabled"

# Remote sources
HOOK_SPARSE_CHECKOUT_URL="https://raw.githubusercontent.com/towo/dotfiles/master/.config/vcsh/hooks-available/pre-upgrade-sparsecheckout"
HOOK_BACKUP_URL="https://raw.githubusercontent.com/towo/dotfiles/master/.config/vcsh/hooks-available/pre-merge.00-backupOriginalFiles"
VCSH_URL="https://raw.githubusercontent.com/towo/dotfiles/master/.local/bin/vcsh"
DOTFILES_URL="https://github.com/towo/dotfiles"

# Ensure we can actually deploy the hooks
mkdir -p "$HOOKS_PATH"

echo -n "Downloading sparse checkout hook: "
curl -so "${HOOKS_PATH}/pre-merge-sparse_checkout" "${HOOK_SPARSE_CHECKOUT_URL}" && echo "done."
echo -n "Downloading backup hook: "
curl -so "${HOOKS_PATH}/pre-merge-backup" "${HOOK_BACKUP_URL}" && echo "done."
echo -n "Downloading bootstrap vcsh: "
curl -so "vcsh-setup.sh" "${VCSH_URL}" && chmod 755 vcsh-setup.sh && echo "done."

echo "Making hooks in ${HOOKS_PATH} executable"
chmod -R 755 ${HOOKS_PATH}

echo "Running initial dotfiles clone"
./vcsh-setup.sh -v clone ${DOTFILES_URL} && rm ${BASE_PATH}/hooks-enabled/pre-merge-{sparse_checkout,backup} && rm vcsh-setup.sh

echo "Making zsh in ${XDG_CONFIG_HOME} the default configuration."
echo 'export ZDOTDIR=$HOME/.config/zsh' > $HOME/.zshenv

echo "Setting current user as default shell user in $XDG_CONFIG_HOME/local."
echo "DEFAULT_USER=$USER" > "${XDG_CONFIG_HOME}/local"

# FIXME: deploy tmux-256color terminfo if necessary

echo "Installing vim plugins."
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config/}" XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share/}" VIMINIT=":source $XDG_CONFIG_HOME/vim/vimrc" vim +'PlugInstall --sync' +qa

if [[ "$SHELL" == *zsh ]]; then
	rehash
fi
