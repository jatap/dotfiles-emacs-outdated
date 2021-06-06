;; -----------------------------------------------------------------------------
;; System Configuration
;; -----------------------------------------------------------------------------

;; exec-path-from-shell
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))
(when (daemonp)
  (exec-path-from-shell-initialize))

;; -----------------------------------------------------------------------------
;; Basic UI Configuration
;; -----------------------------------------------------------------------------

(setq inhibit-startup-message t)

(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room

(menu-bar-mode -1)          ; Disable the menu bar

;; modeline
(column-number-mode)        ; Show column number in the modeline
(global-display-line-numbers-mode 0)

; Disable line numbers for some modes
;; (dolist (mode '(org-mode-hook
;; 		term-mode-hook
;; 		shell-mode-hook
;; 		eshell-mode-hook))
;;   (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; -----------------------------------------------------------------------------
;; Fonts
;; -----------------------------------------------------------------------------

(set-face-attribute 'default nil
  :font "VictorMono Nerd Font"
  :height 120
  :weight 'medium)
(set-face-attribute 'variable-pitch nil
  :font "VictorMono Nerd Font"
  :height 130
  :weight 'medium)
(set-face-attribute 'fixed-pitch nil
  :font "VictorMono Nerd Font"
  :height 120
  :weight 'medium)

;; Makes commented text and keywords italics.
;; This is working in emacsclient but not emacs.
;; Your font must have an italic face available.
(set-face-attribute 'font-lock-comment-face nil
  :slant 'italic)
(set-face-attribute 'font-lock-keyword-face nil
  :slant 'italic)

;; Needed if using emacsclient. Otherwise, your fonts will be smaller than expected.
(add-to-list 'default-frame-alist '(font . "VictorMono Nerd Font-13"))
;; changes certain keywords to symbols, such as lamda!
(setq global-prettify-symbols-mode t)

;; -----------------------------------------------------------------------------
;; Package Manager Configuration
;; -----------------------------------------------------------------------------

;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
 (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
   (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; -----------------------------------------------------------------------------
;; Ivy Ecosystem
;; -----------------------------------------------------------------------------

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)	
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :init
  (setq ivy-height 20)
  :config
  (ivy-mode 1))

;; NOTE: The first time you load your configuration on a new machine, you'll
;; need to run the following command interactively so that mode line icons
;; display correctly:
;;
;; M-x all-the-icons-install-fonts

(use-package all-the-icons)

(use-package ivy-rich
  :after ivy
  :init
  (ivy-rich-mode 1))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
	 ("C-x b" . counsel-switch-buffer)
	 ("C-M-j" . counsel-ibuffer)
	 ("C-x C-f" . counsel-find-file) 
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history))
  :config
  (setq ivy-initial-inputs-alist nil)
  (counsel-mode 1))

(use-package ivy-prescient
  :after counsel
  :custom
  (ivy-prescient-enable-filtering nil)
  :config
  ;; Have sorting remembered across sessions!
  (prescient-persist-mode 1)
  (ivy-prescient-mode 1))

(use-package swiper)

;; -----------------------------------------------------------------------------
;; Buffers
;; -----------------------------------------------------------------------------

(use-package helpful
  :commands (helpful-callable helpful-variable helpful-command helpful-key)
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

;; -----------------------------------------------------------------------------
;; Editor
;; -----------------------------------------------------------------------------

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package visual-fill-column
  :hook (org-mode . efs/org-mode-visual-fill))

(use-package evil-nerd-commenter
  :bind ("M-/" . evilnc-comment-or-uncomment-lines))

;; -----------------------------------------------------------------------------
;; Modeline
;; -----------------------------------------------------------------------------

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))

;; -----------------------------------------------------------------------------
;; Themes
;; -----------------------------------------------------------------------------

(use-package doom-themes
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-palenight t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Enable custom neotree theme (all-the-icons must be installed!)
  ;(doom-themes-neotree-config)
  ;; or for treemacs users
  ;(setq doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
  ;(doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

;; -----------------------------------------------------------------------------
;; Key Binding Configuration
;; -----------------------------------------------------------------------------

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(use-package evil
  :init                             ;; tweak evil's configuration before loading it
  (setq evil-want-integration t)    ;; This is optional since it's already set to t by default
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-Y-yank-to-eol t)
  (setq evil-vsplit-window-right t)
  (setq evil-split-window-below t)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3)) 

(use-package general
  :after evil
  :config
  (general-evil-setup t)

  (general-create-definer jatap/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (jatap/leader-keys
   "a" '(counsel-projectile-rg :which-key "search")
   "*" '(swiper-all-thing-at-point :which-key "search *")
   "," '(counsel-find-file :which-key "find-file")
   "b" '(counsel-projectile-switch-to-buffer :which-key "buffers")
   "B" '(counsel-switch-buffer :which-key "buffers")
   "w" '(save-buffer :which-key "save buffer")
   "j" '(bury-buffer :which-key "bury buffer")
   "q" '(kill-current-buffer :which-key "close buffer")))

(use-package hydra)

(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :exit t))

(jatap/leader-keys
  "ts" '(hydra-text-scale/body :which-key "scale text"))

;; -----------------------------------------------------------------------------
;; Projectile Ecosystem
;; -----------------------------------------------------------------------------

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  ;; NOTE: Set this to the folder where you keep your Git repos!
  (when (file-directory-p "~/Projects")
    (setq projectile-project-search-path '("~/Projects")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

;; -----------------------------------------------------------------------------
;; Magit Ecosystem
;; -----------------------------------------------------------------------------

(use-package magit
  :commands magit-status
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

;; https://magit.vc/manual/forge/Token-Creation.html#Token-Creation
;; https://magit.vc/manual/ghub/Getting-Started.html#Getting-Started
(use-package forge
  :after magit)

;; -----------------------------------------------------------------------------
;; Shell
;; -----------------------------------------------------------------------------

(use-package vterm
  :commands vterm
  :config
  (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *")  ;; Set this to match your custom shell prompt
  ;;(setq vterm-shell "zsh")                       ;; Set this to customize the shell to launch
  (setq vterm-max-scrollback 10000))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(vterm visual-fill-column forge magic-delta hydra exec-path-from-shell helpful which-key rainbow-delimiters ivy-prescient counsel ivy-rich swiper use-package ivy general evil-collection doom-themes doom-modeline command-log-mode)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
