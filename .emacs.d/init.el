;; ▘  ▗
;; ▌▛▘▜▘▛▘ Jean Carlos (jctr)
;; ▌▙▖▐▖▌  https://github.com/jeanctr/
;; ▙▌       https://jeanctr.me

;; -*- lexical-binding: t; -*-
;;; init.el --- Terminal Emacs config: evil + org + markdown + programming

;; --- Package setup ---
(require 'package)
(setq package-archives
      '(("melpa"  . "https://melpa.org/packages/")
        ("gnu"    . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")))
(package-initialize)
(unless package-archive-contents (package-refresh-contents))
(unless (package-installed-p 'use-package) (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;; Silence harmless byte-compile warnings from third-party packages
(setq warning-minimum-level :error)

;; --- Basic UX ---
(setq inhibit-startup-message t
      initial-scratch-message nil
      ring-bell-function 'ignore
      make-backup-files nil
      auto-save-default nil
      create-lockfiles nil
      scroll-conservatively 101
      custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file) (load custom-file))

(setq-default indent-tabs-mode nil tab-width 4)

(global-display-line-numbers-mode 1)
(column-number-mode 1)
(electric-pair-mode 1)          ; auto-close () [] {} ""
(delete-selection-mode 1)
(global-auto-revert-mode 1)     ; reload files changed on disk
(recentf-mode 1)
(savehist-mode 1)
(save-place-mode 1)             ; reopen files where you left them
(global-hl-line-mode 1)         ; highlight the line the cursor is on

(when (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

;; --- Theme ---
(use-package kanagawa-themes
  :config (load-theme 'kanagawa-dragon t))

;; --- Mouse support in terminal ---
(xterm-mouse-mode 1)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))

;; --- Clipboard shared with Windows (WSL) ---
;; Uses clip.exe (copy) and powershell.exe (paste), both already available in WSL.
(defun wsl-copy (text &optional _push)
  (let ((process-connection-type nil))
    (let ((proc (start-process "wsl-copy" nil "clip.exe")))
      (process-send-string proc text)
      (process-send-eof proc))))

(defun wsl-paste ()
  (let ((text (shell-command-to-string "powershell.exe -NoProfile -Command Get-Clipboard 2>/dev/null")))
    (replace-regexp-in-string "\r\n?\\'" "" text)))

(when (and (not (display-graphic-p))
           (executable-find "clip.exe"))
  (setq interprogram-cut-function 'wsl-copy
        interprogram-paste-function 'wsl-paste))

;; --- Evil (vim keybindings) ---
(use-package evil
  :init
  (setq evil-want-integration t
        evil-want-keybinding nil
        evil-want-C-u-scroll t
        evil-undo-system 'undo-redo
        evil-split-window-below t
        evil-vsplit-window-right t)
  :config (evil-mode 1))

(use-package evil-collection
  :after evil
  :config (evil-collection-init))

(use-package evil-commentary
  :after evil
  :config (evil-commentary-mode 1))  ; gcc = comment line

(use-package evil-surround
  :after evil
  :config (global-evil-surround-mode 1))  ; ys, cs, ds = surround

;; --- Leader key (SPC) ---
(use-package general
  :after evil
  :config
  (general-evil-setup)
  (general-create-definer jc/leader-keys
    :states '(normal insert visual emacs)
    :keymaps 'override
    :prefix "SPC"
    :global-prefix "M-SPC")

  (jc/leader-keys
    "SPC" '(execute-extended-command :wk "M-x")
    "."   '(find-file :wk "Find file")

    "h"   '(:ignore t :wk "Help")
    "h r" '((lambda () (interactive) (load-file user-init-file)) :wk "Reload config")

    "f"   '(:ignore t :wk "Files")
    "f r" '(recentf-open :wk "Recent files")
    "f s" '(save-buffer :wk "Save file")

    "b"   '(:ignore t :wk "Buffers")
    "b b" '(consult-buffer :wk "Switch buffer")
    "b k" '(kill-current-buffer :wk "Kill buffer")

    "p"   '(:ignore t :wk "Project")
    "p p" '(projectile-command-map :wk "Projectile")

    "t"   '(:ignore t :wk "Tree")
    "t t" '(neotree-toggle :wk "Toggle file tree")

    "g"   '(:ignore t :wk "Git")
    "g g" '(magit-status :wk "Magit status")

    "w"   '(:ignore t :wk "Windows")
    "w s" '(evil-window-split :wk "Split horizontal")
    "w v" '(evil-window-vsplit :wk "Split vertical")
    "w c" '(evil-window-delete :wk "Close window")
    "w h" '(evil-window-left :wk "Window left")
    "w j" '(evil-window-down :wk "Window down")
    "w k" '(evil-window-up :wk "Window up")
    "w l" '(evil-window-right :wk "Window right")

    "s"   '(:ignore t :wk "Search")
    "s g" '(consult-grep :wk "Grep in project")
    "s l" '(consult-line :wk "Search in buffer")

    "o"   '(:ignore t :wk "Org")
    "o a" '(org-agenda :wk "Org agenda")
    "o t" '(org-todo :wk "Toggle TODO")
    "o c" '(org-capture :wk "Capture task/note")
    "o p" '(org-priority :wk "Set priority")
    "o d" '(org-deadline :wk "Set deadline")
    "o s" '(org-schedule :wk "Schedule task")

    "c"   '(:ignore t :wk "Code")
    "c a" '(eglot-code-actions :wk "Code action")
    "c r" '(eglot-rename :wk "Rename symbol")
    "c f" '(eglot-format :wk "Format buffer")
    "c d" '(xref-find-definitions :wk "Go to definition")))

;; --- Which-key (shows keybindings) ---
(use-package which-key
  :init (which-key-mode 1)
  :diminish
  :config (setq which-key-idle-delay 0.4))

;; --- Completion (minibuffer) ---
(use-package vertico :init (vertico-mode 1))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package marginalia :init (marginalia-mode 1))

(use-package consult
  :bind (("C-s" . consult-line)))

;; --- Completion (in-buffer, while typing code) ---
(use-package company
  :defer 1
  :diminish
  :custom
  (company-idle-delay 0.15)
  (company-minimum-prefix-length 2)
  :config (global-company-mode 1))

;; --- Syntax checking ---
(use-package flycheck
  :defer 1
  :diminish
  :init (global-flycheck-mode 1))

;; --- Project + Git ---
(use-package projectile
  :diminish
  :config (projectile-mode 1))

(use-package magit :commands (magit-status))

;; git changes shown next to line numbers (uses margin in terminal, no fringe there)
(use-package diff-hl
  :hook ((prog-mode . diff-hl-mode)
         (org-mode  . diff-hl-mode))
  :config
  (unless (display-graphic-p)
    (diff-hl-margin-mode 1)))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; --- Status line ---
(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom
  (doom-modeline-icon nil)          ; no icons needed, avoids font issues in terminal
  (doom-modeline-height 25))

;; --- Dashboard (start screen) ---
(use-package dashboard
  :init
  (setq initial-buffer-choice 'dashboard-open
        dashboard-banner-logo-title "Welcome back, Jean"
        dashboard-startup-banner 1      ; text banner (ASCII), no image/icons needed
        dashboard-set-heading-icons nil ; no icons, plain text works everywhere
        dashboard-set-file-icons nil
        dashboard-center-content t
        dashboard-items '((recents  . 5)
                           (agenda  . 5)
                           (projects . 5)))
  :config
  (dashboard-setup-startup-hook))

;; --- File tree sidebar (complements dired, which you already have via SPC .) ---
(use-package neotree
  :commands (neotree-toggle)
  :custom
  (neo-smart-open t)          ; auto-jump to current file's location in the tree
  (neo-show-hidden-files t)
  (neo-window-width 35))

;; --- Org-mode ---
(use-package org
  :ensure nil
  :hook (org-mode . org-indent-mode)
  :custom
  (org-hide-emphasis-markers t)
  (org-startup-folded 'content)
  (org-return-follows-link t)
  (org-confirm-babel-evaluate nil)   ; don't ask every time you run a code block
  (org-src-tab-acts-natively t)      ; TAB behaves like in the language's own mode

  ;; --- Task management ---
  (org-directory "~/org")
  (org-agenda-files '("~/org"))      ; looks at every .org file in this folder
  (org-todo-keywords
   '((sequence "TODO(t)" "DOING(g)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)")))
  (org-todo-keyword-faces
   '(("TODO"      . (:foreground "orange" :weight bold))
     ("DOING"     . (:foreground "yellow" :weight bold))
     ("WAITING"   . (:foreground "violet" :weight bold))
     ("DONE"      . (:foreground "green"  :weight bold))
     ("CANCELLED" . (:foreground "gray"   :weight bold))))
  (org-log-done 'time)               ; timestamp when a task is marked DONE
  (org-agenda-start-with-log-mode t)
  (org-agenda-span 'week)
  (org-capture-templates
   '(("t" "Task" entry (file+headline "~/org/tasks.org" "Inbox")
      "* TODO %?\n  %U\n  %a" :empty-lines 1)
     ("n" "Note" entry (file+headline "~/org/notes.org" "Notes")
      "* %?\n  %U" :empty-lines 1)))
  :config
  (unless (file-directory-p org-directory)
    (make-directory org-directory t))
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (python     . t)
     (shell      . t)
     (C          . t)
     (js         . t)
     (sql        . t))))

(use-package toc-org
  :hook (org-mode . toc-org-enable))

;; --- Markdown ---
(use-package markdown-mode
  :mode ("\\.md\\'" . gfm-mode)
  :custom (markdown-command "multimarkdown"))

;; ===========================================================================
;; Programming language support
;; ===========================================================================

;; Tree-sitter: better syntax highlighting, auto-swap to *-ts-mode when available
(use-package treesit-auto
  :custom (treesit-auto-install 'prompt)
  :config
  (global-treesit-auto-mode))

;; Eglot: built-in LSP client (Emacs 29+). Just run M-x eglot in a supported
;; buffer, or it starts automatically for the modes below.
(use-package eglot
  :ensure nil
  :hook ((python-mode        . eglot-ensure)
         (python-ts-mode     . eglot-ensure)
         (js-mode            . eglot-ensure)
         (js-ts-mode         . eglot-ensure)
         (typescript-mode    . eglot-ensure)
         (typescript-ts-mode . eglot-ensure)
         (go-mode            . eglot-ensure)
         (go-ts-mode         . eglot-ensure)
         (rust-mode          . eglot-ensure)
         (rust-ts-mode       . eglot-ensure)
         (c-mode             . eglot-ensure)
         (c++-mode           . eglot-ensure)
         (php-mode           . eglot-ensure)))

;; Web dev
(use-package typescript-mode)
(use-package web-mode
  :mode ("\\.html?\\'" "\\.vue\\'" "\\.jsx\\'" "\\.tsx\\'"))
(use-package json-mode)

;; Go
(use-package go-mode)

;; Rust
(use-package rust-mode)

;; Systems / embedded
;; c-mode and c++-mode are built into Emacs, no package needed.

;; Bash / shell — built into Emacs as sh-mode, no package needed.

;; SQL — built into Emacs as sql-mode, no package needed.

;; Alternative languages
(use-package lua-mode)
(use-package haskell-mode)
(use-package clojure-mode)
(use-package cider)              ; Clojure REPL, works with clojure-mode
(use-package php-mode)
(use-package kotlin-mode)
(use-package julia-mode)
(use-package zig-mode)

;; Config/data formats
(use-package yaml-mode)
(use-package toml-mode)
(use-package dockerfile-mode)

;; End of init.el
