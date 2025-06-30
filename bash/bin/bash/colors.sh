#!/usr/bin/env bash
# https://gist.github.com/inexorabletash/9122583
# https://gist.github.com/viniciusdaniel/53a98cbb1d8cac1bb473da23f5708836

text-style-help() {
	cat << 'EOF'
Usage:
	 echo -e "... $(text-style style ...) ..."
	 echo -e "... $(text-reset) ..."
	 echo -e "... $(text-color r g b) ..."
	 echo -e "... $(background-color r g b) ..."

Where:
	 styles:
		 black  red  green  yellow  blue  magenta  cyan  white  default
		 (prefix with 'bg' for background color)
		 bold  faint  normal
		 italic  roman
		 underline  nounderline
		 inverse  negative  positive
		 conceal  reveal
		 strike  nostrike
		 xterm N  (two consecutive arguments)
		 bgxterm N  (two consecutive arguments)
		 reset
	 r/g/b in 0...5 for color triplets

Example:
	 echo -e "This is $(text-color 5 5 0) yellow $(text-reset)"
	 echo -e "This is $(text-style bold blue underline) fancy $(text-reset)"
EOF
}

# Usage:
#     echo -e "... $(text-style style ...) ..."
#     echo -e "... $(text-reset) ..."
#     echo -e "... $(text-color r g b) ..."
#     echo -e "... $(background-color r g b) ..."
#
# Where:
#     styles:
#       black  red  green  yellow  blue  magenta  cyan  white  default
#       (prefix with 'bg' for background color)
#       bold  faint  normal
#       italic  roman
#       underline  nounderline
#       inverse  negative  positive
#       conceal  reveal
#       strike  nostrike
#       xterm N  (two consecutive arguments)
#       bgxterm N  (two consecutive arguments)
#       reset
#     r/g/b in 0...5 for color triplets
#
# Example:
#     echo -e "This is $(text-color 5 5 0) yellow $(text-reset)"
#     echo -e "This is $(text-style bold blue underline) fancy $(text-reset)"

function text-style {
    while [ $# -gt 0 ]; do
	case "$1" in
	    reset)       echo -ne "\e[0m" ;;  # terminal default

	    bold)        echo -ne "\e[1m" ;;
	    faint)       echo -ne "\e[2m" ;;  # not widely supported (gnome-terminal does)
	    italic)      echo -ne "\e[3m" ;;  # not widely supported
	    underline)   echo -ne "\e[4m" ;;
	    blink)       echo -ne "\e[5m" ;;  # not widely supported
	    blinkfast)   echo -ne "\e[6m" ;;  # not widely supported
	    negative)    echo -ne "\e[7m" ;;
	    conceal)     echo -ne "\e[8m" ;;  # not widely supported (gnome-terminal does)
	    strike)      echo -ne "\e[9m" ;;  # not widely supported (gnome-terminal does)

	    normal)      echo -ne "\e[22m" ;; # cancel bold/faint
	    roman)       echo -ne "\e[23m" ;; # cancel italic
	    nounderline) echo -ne "\e[24m" ;; # cancel underline
	    noblink)     echo -ne "\e[25m" ;; # cancel blink
	    positive)    echo -ne "\e[27m" ;; # cancel negative
	    reveal)      echo -ne "\e[28m" ;; # cancel conceal
	    nostrike)    echo -ne "\e[29m" ;; # cancel strike

	    black)       echo -ne "\e[30m" ;;
	    red)         echo -ne "\e[31m" ;;
	    green)       echo -ne "\e[32m" ;;
	    yellow)      echo -ne "\e[33m" ;;
	    blue)        echo -ne "\e[34m" ;;
	    magenta)     echo -ne "\e[35m" ;;
	    cyan)        echo -ne "\e[36m" ;;
	    white)       echo -ne "\e[37m" ;;
	    xterm)       echo -ne "\e[38;5;$2m" ; shift ;;

	    default)     echo -ne "\e[39m" ;;

	    bgblack)     echo -ne "\e[40m" ;;
	    bgred)       echo -ne "\e[41m" ;;
	    bggreen)     echo -ne "\e[42m" ;;
	    bgyellow)    echo -ne "\e[43m" ;;
	    bgblue)      echo -ne "\e[44m" ;;
	    bgmagenta)   echo -ne "\e[45m" ;;
	    bgcyan)      echo -ne "\e[46m" ;;
	    bgwhite)     echo -ne "\e[47m" ;;
	    bgxterm)     echo -ne "\e[48;5;$2m" ; shift ;;
	    bgdefault)   echo -ne "\e[49m" ;;

      --help)				 text-style-help ;;
	    *)
		echo -"ne \e[0m"
		echo "Unknown code: $token" 1>&2
		return 1
		;;
	esac
	shift
    done
}

function text-reset {
    text-style reset
}
