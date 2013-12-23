;; Olle K .emacs
;; To make emacs-with-X11 look like emacs-no-X11

;; Clean startup:
(setq inhibit-default-init t)
(setq inhibit-startup-message t)
(setq inhibit-startup-screen t)

;; Clean emacs (comment out menu-bar in X11):
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)


;; Highlight  --------------------- ;;
(load "paren")                      ;; Check () / [] / {} match
(show-paren-mode 1)                 ;; 
(global-font-lock-mode t)           ;; Highlight text..
(setq font-lock-maximum-decoration t)
(transient-mark-mode t)

; Colors:
(set-background-color "Black")
(set-foreground-color "White")
(set-cursor-color     "ForestGreen")

;; Extend chars:
(set-input-mode (car (current-input-mode))
                (nth 1 (current-input-mode))
                0)

;; Auto-complete? Not as good as one might expect
;(require 'auto-complete)
;(global-auto-complete-mode t)

(setq next-line-add-newlines nil)
(setq scroll-step 1)
(setq scroll-conservatively 1)
(setq line-number-mode t)
(setq column-number-mode t)
(setq c-default-style "ellemtel")
(setq-default indent-tabs-mode nil)
(setq c-basic-offset 2)

;; Keybinds:
(global-set-key [f1] 'split-window-horizontally)    ; Split
(global-set-key [f2] 'delete-other-windows)         ; Unsplit
(global-set-key [f3] 'speedbar-get-focus)           ; Easy nav
(global-set-key [f4] 'buffer-menu)                  ; Quick menu
(global-set-key [f5] 'toggle-truncate-lines)        ; Line wrap
;(global-set-key [f6] 'hs-minor-mode)                ; 'hs-minor-mode'

;; Place all backups at ~/.emacs.d/backup:
(setq backup-directory-alist
      `((".*" . , "~/.emacs.d/backup")))
(setq auto-save-file-name-transforms
      `((".*" , "~/.emacs.d/backup" t)))

(custom-set-faces
 '(font-lock-comment-delimiter-face
   ((default (:inherit font-lock-comment-face))
    (((class color)
      (min-colors 8)
      (background dark))
     (:foreground "orange"))))
 '(font-lock-comment-face
   ((((class color)
      (min-colors 8)
      (background dark))
     (:inherit font-lock-comment-delimiter-face))))
 '(speedbar-button-face
   ((((class color)
      (background light))
     (:background "orange" :foreground "black"))))
 '(speedbar-directory-face
   ((((class color)
      (background light))
     (:foreground "orange")))))

;; Shebangs
;(add-to-list 'interpreter-mode-alist
; '("python2.7" . python-mode))
