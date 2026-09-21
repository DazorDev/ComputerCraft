;;; Directory Local Variables            -*- no-byte-compile: t -*-
;;; For more information see (info "(emacs) Directory Variables")

((nil . ((mode . direnv)))
 (fennel-mode . ((fennel-program . "cd \"$(git rev-parse --show-toplevel)\" && fennel --repl")
		 (mode . rainbow-delimiters)
		 (mode . paredit))))
