;; -----------------------------------------------------------------------------
;; Fonts
;; -----------------------------------------------------------------------------
(set-face-attribute 'default nil
  :font "VictorMono Nerd Font"
  :height 130
  :weight 'medium)
(set-face-attribute 'variable-pitch nil
  :font "VictorMono Nerd Font"
  :height 140
  :weight 'medium)
(set-face-attribute 'fixed-pitch nil
  :font "VictorMono Nerd Font"
  :height 130
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

;; Uncomment the following line if line spacing needs adjusting.
;(setq-default line-spacing 0.12)

;; -----------------------------------------------------------------------------
;; Benchmarks
;; -----------------------------------------------------------------------------
(defun efs/display-startup-time ()
  (message "Emacs loaded in %s with %d garbage collections."
           (format "%.2f seconds"
                   (float-time
                     (time-subtract after-init-time before-init-time)))
           gcs-done))

(add-hook 'emacs-startup-hook #'efs/display-startup-time)

;; -----------------------------------------------------------------------------
;; UI settings
;; -----------------------------------------------------------------------------
(setq inhibit-startup-message t)

(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room

(menu-bar-mode -1)            ; Disable the menu bar

;; -----------------------------------------------------------------------------
;; Packages
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
;; doom-modeline
;; -----------------------------------------------------------------------------
(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 35)))

;; -----------------------------------------------------------------------------
;; doom-themes
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
;; evil
;; -----------------------------------------------------------------------------
(use-package evil
  :init                             ;; tweak evil's configuration before loading it
  (setq evil-want-integration t)    ;; This is optional since it's already set to t by default
  (setq evil-want-keybinding nil)
  (setq evil-vsplit-window-right t)
  (setq evil-split-window-below t)
  (evil-mode))
(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

;; -----------------------------------------------------------------------------
;; ivy
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
  :config
  (ivy-mode 1))

;; -----------------------------------------------------------------------------
;; all-the-icons
;; -----------------------------------------------------------------------------
(use-package all-the-icons)

;; -----------------------------------------------------------------------------
;; Keymaps
;; -----------------------------------------------------------------------------
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; General keybindings
;(use-package general
;  :config
;  (general-evil-setup t))
