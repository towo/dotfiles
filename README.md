# towo's dotfiles

Because there aren't enough dotfiles repositories out there, you know.

This repository is focused around using `vcsh`, with technically optional usage
of `mr`.

I'm trying to go for a mostly XDG-compatible approach; this should technically
allow you to just port over `XDG_CONFIG_HOME` when sudoing, as one of the
advantages.

## sparse checkout

This repository has support for sparse checkouts when using vcsh; there's a bit
of a bootstrap problem as vcsh needs to have the hooks available and enabled
before actually pulling any sparse-proof files.

To facilitate this and if you're not using whatever bootstrap script I'll
make/user later, perform the following steps:

* `vcsh dotfiles fetch`
* `vcsh dotfiles checkout sparse_checkout`
* `vcsh upgrade dotfiles`
* `vcsh dotfiles pull`

What this does is check out a version that has
1. sparse checkout configuration
2. no files affected by sparse checkout

Courtesy of the sparse checkout hooks from
[ek9](https://gtihub.com/ek9/vcsh-dotfiles), you'll just have to run the
upgrade process on the repository, which'll configure it to do sparse
checkouts. After that, you won't be getting any `README.md` in your home all of
a sudden.
