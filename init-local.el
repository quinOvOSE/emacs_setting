;;my own system

;;(add-to-list 'load-path "~/.emacs.d/site-lisp/emacs-application-framework/")
;;(require 'eaf)
;;(require 'eaf-browser)
;;(require 'eaf-pdf-viewer)


;;(setq eaf-proxy-type "http")
;;(setq eaf-proxy-host "127.0.0.1")
;;(setq eaf-proxy-port "42705")

(setq org-agenda-span 3)
(global-set-key (kbd "<M-up>") 'shrink-window)
(global-set-key (kbd "<M-down>") 'enlarge-window)
(global-set-key (kbd "<M-left>") 'shrink-window-horizontally)
(global-set-key (kbd "<M-right>") 'enlarge-window-horizontally)

(require 'posframe)
(require 'pyim)

(setq default-input-method "pyim")

;; 金手指设置，可以将光标处的编码，比如：拼音字符串，转换为中文。
(global-set-key (kbd "M-j") 'pyim-convert-string-at-point)

;; 按 "C-<return>" 将光标前的 regexp 转换为可以搜索中文的 regexp.
(define-key minibuffer-local-map (kbd "C-<return>") 'pyim-cregexp-convert-at-point)

;; 我使用全拼
(pyim-default-scheme 'quanpin)
;; (pyim-default-scheme 'wubi)
;; (pyim-default-scheme 'cangjie)

;; pyim 探针设置
;; 设置 pyim 探针设置，这是 pyim 高级功能设置，可以实现 *无痛* 中英文切换 :-)
;; 我自己使用的中英文动态切换规则是：
;; 1. 光标只有在注释里面时，才可以输入中文。
;; 2. 光标前是汉字字符时，才能输入中文。
;; 3. 使用 M-j 快捷键，强制将光标前的拼音字符串转换为中文。
;; (setq-default pyim-english-input-switch-functions
;;               '(pyim-probe-dynamic-english
;;                 pyim-probe-isearch-mode
;;                 pyim-probe-program-mode
;;                 pyim-probe-org-structure-template))

;; (setq-default pyim-punctuation-half-width-functions
;;               '(pyim-probe-punctuation-line-beginning
;;                 pyim-probe-punctuation-after-punctuation))

;; 开启代码搜索中文功能（比如拼音，五笔码等）
(pyim-isearch-mode 1)

;; 设置选词框的绘制方式
(if (posframe-workable-p)
    (setq pyim-page-tooltip 'posframe)
  (setq pyim-page-tooltip 'popup))

;; 显示5个候选词。
(setq pyim-page-length 5)

;; Basedict
(require 'pyim-basedict)
(pyim-basedict-enable)


(add-to-list 'load-path (expand-file-name "~/.emacs.d/elisp/"))
(require 'grep-dired)
(require 'sdcv)

(setq sdcv-dictionary-data-dir "/usr/share/stardict/dic/") ;setup directory of stardict dictionary
(setq sdcv-dictionary-simple-list    ;setup dictionary list for simple search
      '("懒虫简明英汉词典"
        "懒虫简明汉英词典"
        ))
(setq sdcv-dictionary-complete-list     ;setup dictionary list for complete search
      '(
        "懒虫简明英汉词典"
        "懒虫简明汉英词典"
        ))


(require 'company-english-helper)
(global-set-key (kbd "M-k") 'sdcv-search-pointer+)

(add-to-list 'load-path (expand-file-name "~/org-file"))
(add-to-list 'auto-mode-alist '("\\.\\(org\\|org_archive\\|txt\\)$" . org-mode))
(require 'org)

;(setq org-agenda-files (quote ("~/org-file")))
;(setq org-agenda-files '("~/org-file"))
(setq org-agenda-files (directory-files-recursively "~/org-file/" "\\.org$"))

(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory (file-truename "~/RoamNotes"))
  (org-roam-completion-everywhere t)
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         :map org-mode-map
         ("C-M-i"    . completion-at-point))
  :config
  (org-roam-setup)
  (org-roam-db-autosync-mode)
  (setq org-roam-mode-sections
        (list #'org-roam-backlinks-insert-section
              #'org-roam-reflinks-insert-section
              #'org-roam-unlinked-references-insert-section
              ))
  ;; If using org-roam-protocol
  (require 'org-roam-protocol))


(setq org-roam-graph-executable "dot")


;(add-to-list 'load-path "~/.emacs.d/private/org-roam-ui")

(setq org-roam-capture-templates
      '(
        ("d" "default" plain "%?"
         :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                            "#+title: ${title}\n") :unnarrowed t)
        ("l" "literature" plain "- Type: Literature\n- Scope: \n- Author: \n* 相关工作\n\n%?\n* 观点\n\n* 模型和方法\n\n* 实验\n\n* 结论\n"
         :target (file+head "literature/%<%Y%m%d%H%M%S>-${slug}.org"
                            "#+title: ${title}\n") :unnarrowed t)
        ("n" "nation" plain "- Type: Nation\n"
         :target (file+head "nation/%<%Y%m%d%H%M%S>-${slug}.org"
                            "#+title: ${title}\n") :unnarrowed t)
        ("o" "organization" plain "- Type: Organization\n- City: \n- Nation: "
         :target (file+head "organization/%<%Y%m%d%H%M%S>-${slug}.org"
                            "#+title: ${title}\n") :unnarrowed t)
        ("p" "person" plain "- Type: Person\n- Birth year: \n- Organization: \n- Occupation: \n"
         :target (file+head "person/%<%Y%m%d%H%M%S>-${slug}.org"
                            "#+title: ${title}\n") :unnarrowed t)
        ("c" "concept" plain "- Type: Concetpt\n- Scope: \n- Definition: \n- Segmentation: \n"
         :target (file+head "concept/%<%Y%m%d%H%M%S>-${slug}.org"
                            "#+title: ${title}\n") :unnarrowed t)
        )

      )

                                        ;(load-library "org-roam-ui")



(provide 'init-local)
