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

    (setq my-packages '( use-package
			 bind-key
			 zenburn-theme
			 git-commit-mode git-rebase-mode magit magit-annex
			 projectile
			 helm
			 helm-projectile
			 bookmark+
			 uzumaki ))

    (dolist (p my-packages)
      (when (not (package-installed-p p))
	(package-install p)))
    ))


(setq inhibit-splash-screen t)
(setq inhibit-startup-screen t)
(set-default 'truncate-lines t)

;;ask before quiting emacs with C-x C-c
(setq confirm-kill-emacs (quote yes-or-no-p))


(require 'use-package)
(require 'bind-key)
(require 'magit-annex)

(require 'uzumaki)
(uzumaki-minor-mode 1)
(uzumaki-set-cycle-mode 'major-mode)
;; (define-key uzumaki-minor-mode-map (kbd "C-<") nil)
;; (define-key uzumaki-minor-mode-map (kbd "C->") nil)

;;DIRED
;;dired - reuse current buffer by pressing a
(put 'dired-find-alternate-file 'disabled nil)
;;copy from one dired to the next dired shown
(setq dired-dwim-target t)
;;-h, with -l print sizes in human readable format (e.g., 1k 234M 2G)
(setq dired-listing-switches "-alh")

(savehist-mode 1)


;;ORG
(require 'org)
(require 'ob-tangle)
(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   ;;(tcl . t)
   (python . t)
   (sh . t)
   ))

(setq  org-confirm-babel-evaluate nil)

;;BOOKMARK+
(require 'bookmark+)
(setq bookmark-bmenu-toggle-filenames t)
(setq bookmark-sort-flag nil)
(setq bookmark-save-flag t)

(defvar edu/bmkp-choices nil)

(defun edu/bmkp-directory-files (prefix base suffix)
  (let (myDirList myBmk)
    (setq myDirList
          (directory-files (concat user-emacs-directory "bmks") t (concat "^" prefix  base ".*\." suffix "$")))
    (setq edu/bmkp-choices nil)
    (dolist (myFile myDirList)
      (setq myBmk (file-name-nondirectory myFile))
      (string-match (concat "^" prefix base "\\(.*\\)\." suffix "$") myBmk)
      (setq myBmk (match-string 2 myBmk))
      (add-to-list 'edu/bmkp-choices `(,myBmk . ,myFile))
      )))

(defun edu/bmkp-switch-bookmarkfile ()
  (interactive)
  ;;(when (mkst-is-win32) (edu/bmkp-directory-files "bmk" "-\\(all\\|win\\)-" "bmk"))
  ;;(when (mkst-is-unix)  (edu/bmkp-directory-files "bmk" "-\\(all\\|unix\\)-" "bmk"))
  (edu/bmkp-directory-files "bmk" "-\\(all\\|unix\\)-" "bmk")
  (let ((choice (ido-completing-read "bmk: " edu/bmkp-choices nil t)))
    (setq choice (cdr (assoc choice edu/bmkp-choices)))
    (bmkp-switch-bookmark-file choice)
    ))

(defun edu/bookmark-load ()
  (interactive)
  ;; (when (mkst-is-win32) (edu/bmkp-directory-files "bmk" "-\\(all\\|win\\)-" "bmk"))
  ;; (when (mkst-is-unix)  (edu/bmkp-directory-files "bmk" "-\\(all\\|unix\\)-" "bmk"))
  (edu/bmkp-directory-files "bmk" "-\\(all\\|unix\\)-" "bmk")
  (let ((choice (ido-completing-read "bmk: " edu/bmkp-choices nil t)))
    (setq choice (cdr (assoc choice edu/bmkp-choices)))
    (bookmark-load choice)))

(defun edu/bmkp-empty-file (myFile)
  (interactive (list (read-file-name "Create empty bookmark file: " (concat user-emacs-directory "bmks/"))))
  (bmkp-empty-file myFile)
  (bmkp-switch-bookmark-file myFile))


(defun edu/bmkp-set-desktop-bookmark()
  (interactive)
  (with-temp-buffer
    (cd (concat user-emacs-directory "desktops/"))
    (call-interactively 'bmkp-set-desktop-bookmark)))


(defun edu/bookmark-write (myFile)
  (interactive (list (read-file-name "Save in bookmark file: " (concat user-emacs-directory "bmks/"))))
  (bookmark-save t myFile))



;;PROJECTILE
;;(setq projectile-keymap-prefix (kbd "C-c C-p"))
(use-package projectile
  :init
  (progn
    (projectile-global-mode)
    (setq projectile-enable-caching t)
    (setq projectile-enable-project-root t)
    ;;(setq projectile-indexing-method 'native) use system command like git find
    (defconst projectile-mode-line-lighter " P")
    ;;(edu/on-windows (setq projectile-indexing-method 'alien)) ;;http://tuhdo.github.io/helm-projectile.html
    ))

;;HELM
(use-package helm-projectile
  :bind
  ("C-c h" . helm-projectile)
  ("M-o" . helm-projectile))

(use-package helm-bookmark)


;;KEY BINDING
;;helm
(bind-key "C-x <down>" 'helm-filtered-bookmarks global-map)
(bind-key "C-x b" 'helm-mini global-map)
(bind-key "M-O" 'helm-projectile-switch-project global-map)
(bind-key "M-x" 'helm-M-x global-map)
(bind-key  "M-y"         'helm-show-kill-ring global-map)
;;(bind-key  "C-c f"       'helm-recentf global-map)
(bind-key  "C-x C-f"     'helm-find-files global-map)
(bind-key  "C-x C-d"     'helm-browse-project global-map)
(bind-key  "C-h C-f"     'helm-apropos global-map)

;;dired
(bind-key "C-c j" 'dired-jump global-map)

;;bmkp
(bind-key "C-x p w" 'edu/bookmark-write global-map)
(bind-key "C-x p 0" 'edu/bmkp-empty-file global-map)
;;(bind-key "C-x p l" 'edu/bookmark-load global-map)
(bind-key "C-x p l" 'edu/bmkp-switch-bookmarkfile global-map)
(bind-key "C-x p L" 'edu/bmkp-switch-bookmarkfile global-map)
(bind-key "C-x p K" 'edu/bmkp-set-desktop-bookmark global-map)
(bind-key "C-x r K" 'edu/bmkp-set-desktop-bookmark global-map)

;;functions defines in kde-emacs
(bind-key "C-%" 'match-paren global-map) ;;for all buffers :)

(bind-key "C-c j" 'dired-jump global-map)
(bind-key "<f11>" 'uzumaki-cycle-to-prev-buffer global-map)
(bind-key "<f12>" 'compile global-map)
