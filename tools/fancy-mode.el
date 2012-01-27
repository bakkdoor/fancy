;;; fancy-mode.el --- Major mode for programming with the Fancy language.
;;
;; URL: http://www.fancy-lang.org
;; Version: 0.1
;; Author: Christopher Bertels <chris@fancy-lang.org>


(require 'generic-x)

(define-generic-mode
  'fancy-mode
  '("#")                              ;; comments
  '("def" "class" "try" "catch"
    "finally" "retry" "return"
    "return_local" "require:"
    "match" "case" "->" "=>")             ;; keywords

  '(;; symbols
    ("\\('\\(\\([^\s\n\(\)\{\}\,]+\\|\\]+\\)\\)\\)" 1 font-lock-reference-face)
    ;; fixnums
    ("[0-9]+" . 'font-lock-variable-name-face)
    ;; floats
    ("[0-9]+\.[0-9]+" 'font-lock-variable-name-face)
    ;; dynamic vars
    ("\*[a-zA-Z0-9_-]+\*" . font-lock-reference-face)
    ;; variables & pseudo variables
    ("\\(^\\|[^_:.@$]\\|\\.\\.\\)\\b\\(super\\|nil\\|self\\|true\\|false\\)\\>" 2 font-lock-variable-name-face)
    ;; variable names
    ("\\(\\$\\([^a-zA-Z0-9 \n]\\|[0-9]\\)\\)\\W" 1 font-lock-variable-name-face)
    ;; instance & class vars
    ("\\(\\$\\|@\\|@@\\)\\(\\w\\|_\\)+" 0 font-lock-variable-name-face)
    ;; method definitions
    ("^\\s *def\\s +\\([^( \t\n]+\\)" 1 font-lock-function-name-face)
    ;; message selectors
    ("\\<[A-z][A-z0-9_-+?!=*/^><%]*:" . font-lock-function-name-face)
    ;; operators
    ("\\([-+*/~,<>=&!?%^]+ \\)" 1 'font-lock-function-name-face)
     ;; general delimited string
    ("\\(^\\|[[ \t\n<+(,=]\\)\\(%[xrqQwW]?\\([^<[{(a-zA-Z0-9 \n]\\)[^\n\\\\]*\\(\\\\.[^\n\\\\]*\\)*\\(\\3\\)\\)" (2 font-lock-string-face))
    ;; constants
    ("\\(^\\|[^_]\\)\\b\\([A-Z]+\\(\\w\\|_\\)*\\)" 2 font-lock-type-face))

  '("\\.fy$")                      ;; files for which to activate this mode
   nil                             ;; other functions to call
  "A mode for fancy files"         ;; doc string for this mode
)

(add-to-list 'auto-mode-alist '("\\.fy\\'" . fancy-mode))
(add-to-list 'auto-mode-alist '("\\.fancypack\\'" . fancy-mode))

;; Ignore .fyc (compiled fancy bytecode) files
(add-to-list 'completion-ignored-extensions ".fyc")

(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
(setq indent-line-function 'insert-tab)

(setq do-indent nil)
(defun fancy-indent-line ()
  ;(indent-line-to (+ (current-indentation) 2)))
  (progn
    (if (= (current-indentation) 0)
        (setq do-indent nil))
    (if do-indent
        (indent-line-to (+ (current-indentation) 2))
      (progn
        (indent-relative)
        (setq do-indent t)))))

(setq indent-line-function 'fancy-indent-line)

(provide 'fancy-mode)

;; fancy-mode.el ends here
