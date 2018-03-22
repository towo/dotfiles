# Module to integrate the vcsh-recommended config.d/available.d structure
# Sadly, we can't define enable/disable commands without modifying mr itself.
# … so at some point, I might just fork it.
#  vim: set ft=conf ts=8 sw=8 tw=0 noet :
git_register =
	CONFIG="${XDG_CONFIG_HOME:-$HOME/.config/}/mr/available.d/$MR_REPO.git"
	url="`LC_ALL=C git config --get remote.origin.url`" || true
	if [ -z "$url" ]; then
		error "cannot determine git url"
	fi
	echo "Registering git repository \"$MR_REPO\" (remote $url) to $CONFIG"
	mr -c "$CONFIG" config "`pwd`" checkout="git clone '$url' '$MR_REPO'"
svn_register =
	CONFIG="${XDG_CONFIG_HOME:-$HOME/.config/}/mr/available.d/$MR_REPO.svn"
	url=`LC_ALL=C svn info . | grep -i '^URL:' | cut -d ' ' -f 2`
	if [ -z "$url" ]; then
		error "cannot determine svn url"
	fi
	echo "Registering svn repository \"$MR_REPO\" ($url) in $MR_CONFIG"
	mr -c "$CONFIG" config "`pwd`" checkout="svn co '$url' '$MR_REPO'"
bzr_register =
	CONFIG="${XDG_CONFIG_HOME:-$HOME/.config/}/mr/available.d/$MR_REPO.bzr"
	url="`LC_ALL=C bzr info . | egrep -i 'checkout of branch|parent branch' | awk '{print $NF}' | head -n 1`"
	if [ -z "$url" ]; then
		error "cannot determine bzr url"
	fi
	echo "Registering bzr repository \"$MR_REPO\" ($url) in $MR_CONFIG"
	mr -c "$CONFIG" config "`pwd`" checkout="bzr branch '$url' '$MR_REPO'"
cvs_register =
	CONFIG="${XDG_CONFIG_HOME:-$HOME/.config/}/mr/available.d/$MR_REPO.cvs"
	repo=`cat CVS/Repository`
	root=`cat CVS/Root`
	if [ -z "$root" ]; then
		error "cannot determine cvs root"
		fi
	echo "Registering cvs repository $repo at root $root"
	mr -c "$CONFIG" config "`pwd`" checkout="cvs -d '$root' co -d '$MR_REPO' '$repo'"
hg_register =
	CONFIG="${XDG_CONFIG_HOME:-$HOME/.config/}/mr/available.d/$MR_REPO.hg"
	url=`hg showconfig paths.default`
	echo "Registering mercurial repository \"$MR_REPO\" ($url) in $MR_CONFIG"
	mr -c "$CONFIG" config "`pwd`" checkout="hg clone '$url' '$MR_REPO'"
darcs_register =
	CONFIG="${XDG_CONFIG_HOME:-$HOME/.config/}/mr/available.d/$MR_REPO.darcs"
	url=`cat _darcs/prefs/defaultrepo`
	echo "Registering darcs repository \"$MR_REPO\" ($url) in $MR_CONFIG"
	mr -c "$CONFIG" config "`pwd`" checkout="darcs get '$url' '$MR_REPO'"
git_bare_register =
	CONFIG="${XDG_CONFIG_HOME:-$HOME/.config/}/mr/available.d/$MR_REPO.git_bare"
	url="`LC_ALL=C GIT_CONFIG=config git config --get remote.origin.url`" || true
	if [ -z "$url" ]; then
		error "cannot determine git url"
	fi
	echo "Registering git repository \"$MR_REPO\" ($url) in $MR_CONFIG"
	mr -c "$CONFIG" config "`pwd`" checkout="git clone --bare '$url' '$MR_REPO'"
fossil_register =
	CONFIG="${XDG_CONFIG_HOME:-$HOME/.config/}/mr/available.d/$MR_REPO.fossil"
	url=`fossil remote-url`
	repo=`fossil info | grep repository | sed -e 's/repository:*.//g' -e 's/ //g'`
	echo "Registering fossil repository \"$MR_REPO\" ($url) in $MR_CONFIG"
	mr -c "$CONFIG" config "`pwd`" checkout="mkdir -p '$MR_REPO' && cd '$MR_REPO' && fossil open '$repo'"
veracity_register =
	CONFIG="${XDG_CONFIG_HOME:-$HOME/.config/}/mr/available.d/$MR_REPO.veracity"
	url=`vv config | grep sync_targets | sed -e 's/sync_targets:*.//g' -e 's/ //g'`
	repo=`vv repo info | grep repository | sed -e 's/Current repository:*.//g' -e 's/ //g'`
	echo "Registering veracity repository \"$MR_REPO\" ($url) in $MR_CONFIG"
	mr -c "$CONFIG" config "`pwd`" checkout="mkdir -p '$MR_REPO' && cd '$MR_REPO' && vv checkout '$repo'"
