;;              -*- coding: utf-8-unix -*-



;;How do I install Org-mode through Emacs' Package Manager?

;; First edit .emacs file and comment out the loading of our-site-start.el and my-init.el
;; Restart emacs
;; You can install Org with M-x `package-install' RET `org'.
;; Edit once again the .emacs file and remove the comment around the loading of our-site-start.el and my-init.el
;; Restart emacs

;;You need to do this in a session where no .org file has been visited. Then, to
;;make sure your Org configuration is taken into account, initialize the package
;;system with (package-initialize) in your .emacs before setting any Org option.

;;Use M-x locate-library RET org. If your installation is successful you would something like the following:
;;Library is file ~/.emacs.d/elpa/org-20110403/org.elc


(when (> emacs-major-version 23)

  (require 'package)

  (let (my-packages)
    (setq package-archives nil)

    ;; (add-to-list 'package-archives
    ;; 		 '("marmalade" . "http://marmalade-repo.org/packages/") t)
    ;; (add-to-list 'package-archives
    ;; 		 '("ELPA" . "http://tromey.com/elpa/"))

    (add-to-list 'package-archives
    		 '("melpa" . "http://melpa.org/packages/") t)

    ;;to load org-mode
    (add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)

    ;; (add-to-list 'package-archives
    ;; 		 '("SC"   . "http://joseito.republika.pl/sunrise-commander/") t)

    ;;`package-user-dir' must be set before calling (package-initialize)
    ;;(setq package-user-dir (concat mkst-emacshome-dir "site-lisp/"))

    ;;Apart from this directory, Emacs also looks for system-wide packages in
    ;;`package-directory-list'.

    ;;`package-initalize' also sets `load-path' to include to the package directories

    ;;The packages that you install with `package.el' are activated by default after
    ;;your `.emacs' is loaded. To be able to use them before the end of your .emacs
    ;;you need to activate them by using the command `package-initialize'.

    ;; Comments pasted from `package.el':
    ;; The downloader downloads all dependent packages.  By default,
    ;; packages come from the official GNU sources, but others may be
    ;; added by customizing the `package-archives' alist.  Packages get
    ;; byte-compiled at install time.
    ;; At activation time we will set up the load-path and the info path,
    ;; and we will load the package's autoloads.  If a package's
    ;; dependencies are not available, we will not activate that package.

    (package-initialize)

    (when (not package-archive-contents)
      (package-refresh-contents))

    (setq my-packages '(bind-key git-commit-mode git-rebase-mode magit magit-annex uzumaki))

    (dolist (p my-packages)
      (when (not (package-installed-p p))
	(package-install p)))
    ))


(require 'bind-key)
(require 'magit-annex)

(require 'uzumaki)
(uzumaki-minor-mode 1)
(uzumaki-set-cycle-mode 'major-mode)
;; (define-key uzumaki-minor-mode-map (kbd "C-<") nil)
;; (define-key uzumaki-minor-mode-map (kbd "C->") nil)

;;dired

;;dired - reuse current buffer by pressing a
(put 'dired-find-alternate-file 'disabled nil)

;;copy from one dired to the next dired shown
(setq dired-dwim-target t)

(bind-key "C-c j" 'dired-jump global-map)
(bind-key "<f11>" 'uzumaki-cycle-to-prev-buffer global-map)
(bind-key "<f12>" 'compile global-map)
