(require 'notmuch)
(define-key notmuch-search-mode-map "u" 'notmuch-mark-as-read)
(define-key notmuch-search-mode-map "U" 'notmuch-mark-all-read)

(define-key notmuch-search-mode-map (kbd "S-<f9>") 'notmuch-search-remove-todo)
(define-key notmuch-search-mode-map (kbd "<f9>") 'notmuch-search-add-todo)

(define-key notmuch-search-mode-map "d" 'notmuch-mark-deleted)
(define-key notmuch-search-mode-map "s" 'notmuch-mark-as-spam)

(define-key notmuch-show-mode-map "c" 'bbdb/notmuch-snarf-from)
(define-key notmuch-show-mode-map "C" 'bbdb/notmuch-snarf-to)

;; Bounce key for bouncing message
(define-key notmuch-show-mode-map "b"
  (lambda (&optional address)
    "Bounce the current message."
    (interactive "sBounce To: ")
    (notmuch-show-view-raw-message)
    (message-resend address)))

(define-key notmuch-show-mode-map "d"
  (lambda ()
    "toggle deleted tag for message"
    (interactive)
    (if (member "deleted" (notmuch-show-get-tags))
        (notmuch-show-tag (list "-deleted"))
      (notmuch-show-tag (list "+deleted")))))
