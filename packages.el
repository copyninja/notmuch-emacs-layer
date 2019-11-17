;;; packages.el --- notmuch layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2017 Sylvain Benner & Contributors
;;
;; Author: Vasudev Kamath <vasudev@copyninja.info>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;;; Commentary:

;; See the Spacemacs documentation and FAQs for instructions on how to implement
;; a new layer:
;;
;;   SPC h SPC layers RET
;;
;;
;; Briefly, each package to be installed or configured by this layer should be
;; added to `notmuch-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `notmuch/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `notmuch/pre-init-PACKAGE' and/or
;;   `notmuch/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:

(defconst notmuch-packages
  '(
    notmuch
    bbdb
    smtpmail-multi
    gnus
    ))

(defun notmuch/init-notmuch ()
  (use-package notmuch
    :defer t
    ))

(defun notmuch/init-smtpmail-multi ()
  (use-package smtpmail-multi
    :defer t
    ))

(defun notmuch/init-gnus ()
  (use-package gnus
    :defer t
    ))

(defun notmuch/init-bbdb ()
  (use-package bbdb
    :defer t
    ))
