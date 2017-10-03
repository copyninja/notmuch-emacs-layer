;; Display number of message on refresh of notmuch
(defun notmuch-hello-refresh-status-message ()
  (unless no-display
    (let* ((new-count
            (string-to-number
             (car (process-lines notmuch-command "count"))))
           (diff-count (- new-count notmuch-hello-refresh-count)))
      (cond
       ((= notmuch-hello-refresh-count 0)
        (message "You have %s messages."
                 (notmuch-hello-nice-number new-count)))
       ((> diff-count 0)
        (message "You have %s more messages since last refresh."
                 (notmuch-hello-nice-number diff-count)))
       ((< diff-count 0)
        (message "You have %s fewer messages since last refresh."
                 (notmuch-hello-nice-number (- diff-count)))))
      (setq notmuch-hello-refresh-count new-count))))

(defun notmuch-mark-all-read()
  "Mark all as read in current search"
  (interactive)
  (notmuch-search-tag-all (list "-unread"))
  (notmuch-search-refresh-view))

(defun notmuch-search-tag-and-advance (&rest tags)
  "Add tag or set of tags to current thread"
  (mapc 'notmuch-search-tag tags)
  (notmuch-search-next-thread))

(defun notmuch-mark-as-read()
  "Mark current thread as read"
  (interactive)
  (notmuch-search-tag-and-advance (list "-unread")))

(defun notmuch-mark-as-spam()
  "Mark the current message as spam"
  (interactive)
  (notmuch-search-tag-and-advance (list "+Spam" "-inbox" "-unread")))

(defun notmuch-search-add-todo ()
  "Add 'TODO' tag when in search-mode"
  (interactive)
  (notmuch-search-tag-and-advance (list "+TODO")))

(defun notmuch-search-remove-todo ()
  "Remove a 'TODO' tag in search mode"
  (interactive)
  (notmuch-search-tag-and-advance (list "-TODO")))

(defun notmuch-mark-deleted ()
  "Add 'deleted' tag in search mode"
  (interactive)
  (notmuch-search-tag-and-advance (list "+deleted")))

;; Functions copied from
;; https://notmuchmail.org/pipermail/notmuch/2012/011692.html
(require 'bbdb-autoloads)
(require 'bbdb)
(defun bbdb/notmuch-snarf-header (header)
  (let ((text (notmuch-show-get-header header)))
    (with-temp-buffer
      (insert text)
      (bbdb-snarf-region (point-min) (point-max)))))

(defun bbdb/notmuch-snarf-from ()
  (interactive)
  (bbdb/notmuch-snarf-header :From))

(defun bbdb/notmuch-snarf-to ()
  (interactive)
  (bbdb/notmuch-snarf-header :To))

;; color from line according to known / unknown sender
                                        ; code taken from bbdb-gnus.el
(defun bbdb/notmuch-known-sender ()
  (let* ((from (plist-get headers :From))
         (splits (mail-extract-address-components from))
         (name (car splits))
         (net (cadr splits))
         (record (and splits
                      (bbdb-search-simple
                       name
                       (if (and net bbdb-canonicalize-net-hook)
                           (bbdb-canonicalize-address net)
                         net)))))
    (and record net (member (downcase net) (bbdb-record-net record)))))

(defun bbdb/check-known-sender ()
  (interactive)
  (if (bbdb/notmuch-known-sender) (message "Sender is known") (message "Sender is not known")))

(defface notmuch-show-known-addr
  '(
    (((class color) (background dark)) :foreground "spring green")
    (((class color) (background light)) :background "spring green" :foreground "black"))
  "Face for sender or recipient already listed in bbdb"
  :group 'notmuch-show
  :group 'notmuch-faces)

(defface notmuch-show-unknown-addr
  '(
    (((class color) (background dark)) :foreground "dark orange")
    (((class color) (background light)) :background "gold" :foreground "black"))
  "Face for sender or recipient not listed in bbdb"
  :group 'notmuch-show
  :group 'notmuch-faces)

                                        ; override function from notmuch-show
(defun notmuch-show-insert-headerline (headers date tags depth)
  "Insert a notmuch style headerline based on HEADERS for a
message at DEPTH in the current thread."
  (let ((start (point))
        (face (if (bbdb/notmuch-known-sender) 'notmuch-show-known-addr 'notmuch-show-unknown-addr))
        (end-from))
    (insert (notmuch-show-spaces-n (* notmuch-show-indent-messages-width depth))
            (notmuch-show-clean-address (plist-get headers :From)))
    (setq end-from (point))
    (insert
     " ("
     date
     ") ("
     (propertize (mapconcat 'identity tags " ")
                 'face 'notmuch-tag-face)
     ")\n")
    (overlay-put (make-overlay start (point)) 'face 'notmuch-message-summary-face)
    (save-excursion
      (goto-char start)
      (overlay-put (make-overlay start end-from) 'face face))))
