;; Not much related configurations
(defvar notmuch-hello-refresh-count 0)
(setq mail-user-agent 'message-user-agent)

(custom-set-variables
 '(message-send-hook (quote (notmuch-message-mark-replied)))
 '(notmuch-address-command "notmuch-addrlookup")
 '(notmuch-always-prompt-for-sender t)
 '(notmuch-crypto-process-mime t)
 '(notmuch-fcc-dirs
   (quote
    (("vasudev-debian@copyninja.info" . "vasudev-debian/Sent")
     ("vasudev@debian.org" . "vasudev-debian/Sent")
     ("vasudev@copyninja.info" . "vasudev-copyninja.info/Sent")
     ("kamathvasudev@gmail.com" . "Gmail-1/Sent"))))
 '(notmuch-hello-tag-list-make-query "tag:unread")
 '(notmuch-message-headers (quote ("Subject" "To" "Cc" "Bcc" "Date" "Reply-To")))
 '(notmuch-saved-searches
   (quote
    ((:name "debian-devel" :query "tag:debian-devel and tag:unread")
     (:name "debian-fonts" :query "tag:debian-fonts and tag:unread")
     (:name "debian-india" :query "tag:debian-india and tag:Debian-India and tag:unread")
     (:name "debian-devel-announce" :query "tag:debian-devel-announce and tag:unread")
     (:name "Plan9 and 9Front" :query "tag:9fans and and tag:9front and tag:unread")
     (:name "rkrishnan" :query "tag:rkrishnan and tag:unread")
     (:name "Gmail/INBOX" :query "folder:Gmail-1/INBOX and tag:unread")
     (:name "vasudev/INBOX" :query "folder:vasudev-copyninja.info/INBOX and tag:unread")
     (:name "vasudev-debian/INBOX" :query "folder:vasudev-debian/INBOX and tag:unread")
     (:name "debian-project" :query "tag:debian-project and tag:unread")
     (:name "libindic-dev" :query "tag:libindic-dev and tag:unread")
     (:name "TODO" :query "tag:TODO")
     (:name "debian-rust" :query "tag:pkg-rust and tag:unread")
     (:name "Tahoe Development" :query "tag:tahoe-dev and tag:unread")
     (:name "Intrigeri conversations" :query "tag:nm-process and tag:unread")
     (:name "Debian Multimedia (my packages)"
            :query "tag:pkg-multimedia and tag:unread and \( subject:(rem.*):.* or subject:(librem.*):.* \)")
     (:name "Debian VoIP (my packages)"
            :query "tag:pkg-voip and tag:unread and subject:(*libre*):.* or subject:(baresip*):.* or subject:(biboumi*):.*"))))
 '(notmuch-search-line-faces
   (quote
    (("deleted" :foreground "red")
     ("unread" :weight bold)
     ("flagged" :foreground "blue"))))
 '(notmuch-search-oldest-first nil)
 '(notmuch-show-all-multipart/alternative-parts nil)
 '(notmuch-show-all-tags-list t)
 '(notmuch-show-insert-text/plain-hook
   (quote
    (notmuch-wash-convert-inline-patch-to-part notmuch-wash-tidy-citations
                                               notmuch-wash-elide-blank-lines
                                               notmuch-wash-excerpt-citations))))

(add-hook 'notmuch-hello-refresh-hook 'notmuch-hello-refresh-status-message)

;; SMTP mail multi related configurations
(setq smtpmail-multi-accounts
      '((copyninja-mail "vasudev" "localhost" 25
                        header nil nil nil "rudra")
        (gmail-primary nil "localhost" 25
                       header nil nil nil "rudra")))
(setq smtpmail-multi-assosications
      '((("From" . "kamathvasudev@gmail.com")
         gmail-primary)
        (("From" . "vasudev@copyninja.info")
         copyninja-mail)
        (("From" . "vasudev@debian.org")
         copyninja-mail)))

;; Message sending functions
(setq send-mail-function 'smtpmail-multi-send-it
      message-send-mail-function 'smtpmail-multi-send-it
      smtpmail-auth-credntials "/home/vasudev/.authinfo.gpg")


;; GNUS posting style
(require 'gnus-art)
(setq gnus-posting-styles
      '(((header "to" "kamathvasudev@gmail.com")
         (address "kamathvasudev@gmail.com"))
        ((header "to" "vasudev@copyninja.info")
         (address "vasudev@copyninja.info"))
        ((header "to" "vasudev-debian@copyninja.info")
         (address "vasudev@debian.org"))
        ((header "to" "vasudev@debian.org")
         (address "vasudev@debian.org"))))

;; Enable bbdb configurations
(require 'bbdb-autoloads)
(require 'bbdb)
(bbdb-initialize 'message 'gnus 'sendmail)
(setq bbdb-file "~/.bbdb.db")

;; size of bbdb popup
(setq bbdb-pop-up-window-size 10)

;; What do we do when invoking bbdb interactively
(setq bbdb-mua-update-interactive-p '(query . create))

;; Make sure we look at every address in a message and not only the
;; first one
(setq bbdb-message-all-addresses t)

(setq bbdb/mail-auto-create-p t
      bbdb/news-auto-create-p t)

(add-hook 'message-mode-hook
          '(lambda ()
             (flyspell-mode t)
             (local-set-key "<TAB>" 'bbdb-complete-name)))
