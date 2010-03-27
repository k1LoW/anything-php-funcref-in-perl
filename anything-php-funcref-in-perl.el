;;; anything-php-funcref-in-perl.el --- docs-php-funcref-in-perl anything.el interface
;; -*- Mode: Emacs-Lisp -*-

;; Copyright (C) 2010 by 101000code/101000LAB
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
;;
;; Version: 0.0.1
;; Author: k1LoW (Kenichirou Oyama), <k1lowxb [at] gmail [dot] com> <k1low [at] 101000lab [dot] org>
;; URL: http://code.101000lab.org

;;; Install
;; Put this file into load-path'ed directory, and byte compile it if
;; desired.  And put the following expression into your ~/.emacs.
;;
;; (require 'anything-php-funcref-in-perl)
;;
;; Set docs-php-funcref-in-perl repogitory.
;;
;; $ git clone git://github.com/yappo/docs-php-funcref-in-perl.git
;;
;; (setq anything-php-funcref-in-perl-docs "/path/to/docs-php-funcref-in-perl/docs/")
;; (setq anything-php-funcref-in-perl-docs-template "/path/to/docs-php-funcref-in-perl/docs-template/")
;;
;; If you call drill instructor for Emacs, M-x anything-php-funcref-in-perl.
;;

;;; Change Log
;; 0.0.1 First released.

;;; Code:

(require 'anything)
(require 'cl)

(defvar anything-php-funcref-in-perl-docs "~/repos/docs-php-funcref-in-perl/docs/")
(defvar anything-php-funcref-in-perl-docs-template "~/repos/docs-php-funcref-in-perl/docs-template/")

(defun anything-php-funcref-in-perl ()
  (interactive)
  (let* ((initial-pattern (regexp-quote (or (thing-at-point 'symbol) ""))))
    (anything (list
               anything-c-source-php-funcref-in-perl-docs
               anything-c-source-php-funcref-in-perl-docs-template)
              initial-pattern "PHP function: " nil)))

(defvar anything-c-source-php-funcref-in-perl-docs
  '((name . "Docs PHP funcref in Perl")
    (candidates . (lambda ()
                    (anything-php-funcref-in-perl-file-list
                     (expand-file-name anything-php-funcref-in-perl-docs)
                     anything-php-funcref-in-perl-docs)))
    (display-to-real . (lambda (candidate)
                         (concat anything-php-funcref-in-perl-docs candidate ".txt")))
    (type . file)))
;;(anything 'anything-c-source-php-funcref-in-perl-docs)

(defvar anything-c-source-php-funcref-in-perl-docs-template
  '((name . "Docs Template PHP funcref in Perl")
    (candidates . (lambda ()
                    (anything-php-funcref-in-perl-file-list
                     (expand-file-name anything-php-funcref-in-perl-docs-template)
                     anything-php-funcref-in-perl-docs-template)))
    (display-to-real . (lambda (candidate)
                         (concat anything-php-funcref-in-perl-docs-template candidate ".txt")))
    (action
     ("Edit Docs" . (lambda (candidate)
                      (let ((dir (replace-regexp-in-string
                                  (concat anything-php-funcref-in-perl-docs-template "\\([^/]+\\)/[^/]+\\.txt$")
                                  (concat anything-php-funcref-in-perl-docs "\\1")
                                  candidate))
                            (docs-path (replace-regexp-in-string
                                  "docs-template/"
                                  "docs/"
                                  candidate)))
                        (if (not (executable-find "git"))
                            (message "no git command.")
                        (unless (file-directory-p dir)
                          (make-directory dir))
                        ;;(call-process "git" nil t t "mv" (expand-file-name candidate) (expand-file-name docs-path))
                        (call-process "mv" nil nil nil (expand-file-name candidate) (expand-file-name docs-path))
                        (find-file docs-path)
                      ))))
)))
;;(anything 'anything-c-source-php-funcref-in-perl-docs-template)

(defun anything-php-funcref-in-perl-file-list (file-list path)
  (let ((path-list nil))
    (unless (listp file-list)
      (setq file-list (list file-list)))
    (loop for x
          in file-list
          do (if (file-directory-p x)
                 (setq path-list
                       (append
                        path-list
                        (anything-php-funcref-in-perl-file-list
                         (remove-if
                          (lambda(y) (string-match "\\.$\\|\\.svn\\|\\.git" y))
                          (directory-files x t))
                         path)))
               (if (string-match (concat (expand-file-name path) "\\(.+\\)\\.txt$") x)
                   (setq path-list (push (match-string 1 x) path-list)))))
    (nreverse path-list)))

(provide 'anything-php-funcref-in-perl)