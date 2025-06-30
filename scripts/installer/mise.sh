#!/usr/bin/env bash
# Setup common tools with mise
# mise use -g rust

RUST_BINSTALL=(
	hyperfine
	fd-find
	eza
)

main() {
	# install mise to $HOME/.local/bin/mise
	curl https://mise.run | sh
}
