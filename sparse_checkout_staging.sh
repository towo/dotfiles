#!/bin/zsh
DOTFILES_REPO="dotfiles"

vcsh $DOTFILES_REPO fetch >/dev/null

LAST_TAG=$(vcsh $DOTFILES_REPO describe --abbrev=0 --match 'sparse_checkout*')
ALL_TAGS=("${(@f)$(vcsh $DOTFILES_REPO tag --list 'sparse_checkout*')}")
typeset -a REMAINING_TAGS

for tag in $ALL_TAGS; do
	if [[ $tag > $LAST_TAG && $tag != $LAST_TAG ]]; then
		REMAINING_TAGS=( $REMAINING_TAGS $tag );
	fi
done
unset tag

if [[ ${#REMAINING_TAGS[@]} -gt 0 ]]; then
	for tag in $REMAINING_TAGS; do
		echo "Checking out $tag for $DOTFILES_REPO:"
		vcsh $DOTFILES_REPO checkout $tag >/dev/null && \
			echo "Running upgrade for $DOTFILES_REPO:" && \
			vcsh upgrade $DOTFILES_REPO
		TEXT=$(cat <<-EOF
		Check if upgrades were correctly replied and press enter to \
		continue to any remaining tags.
		EOF
		)
		# Adhering to 80 characters can be pretty shitty.
		echo $TEXT
		read
	done
	echo "You can safely upgrade to the current master branch (probably):"
	echo "vcsh-dotfiles $DOTFILES_REPO checkout master"
	echo "vcsh-dotfiles $DOTFILES_REPO pull"
else
	echo "No new sparse checkout tags present, HAND."
fi
