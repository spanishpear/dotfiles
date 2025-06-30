#!/usr/bin/env bash
# When looking for something on a users PATH, functions, builtins
# it can be pretty annoying.
# Trivia Q) what is the difference between `which` `type` `command` `whence` `where` `whereis` `whatis` `hash` ?
# History - https://unix.stackexchange.com/questions/85249/why-not-use-which-what-to-use-then
exists() {
	CHECK_CMD="$1"
	if command -v "$CHECK_CMD" > /dev/null; then
		return 0
	else
		# no particular meaning, just non-0
		return 2
	fi
}


# e.g. `requires "jq"`
# https://iangilham.com/2018/02/22/declaring-required-commands-in-bash-scripts.html
requires() {
    if ! exists $1; then
        echo "Requires $1"
        exit 1
    fi
}

