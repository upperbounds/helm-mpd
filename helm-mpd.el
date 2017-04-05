;;; helm-mpd.el --- Use Music Player Daemon (MPD) with helm. -*- lexical-binding: t -*-
;; Copyright (C) 2017 Swiss Mysteries

;;; Commentary:

;; Author: Swiss Mister <swiss.mister@posteo.net>
;; Keywords: multimedia

;;; Code:

(require 'libmpdee)

(provide 'helm-mpd)

(defvar mpd-conn (mpd-conn-new "localhost" 6600))

;;(mapcar (lambda (a) a) (mpd-get-artists mpd-conn))


(defun helm-mpd-all-songs () (loop for cand in (mpd-get-songs mpd-conn "listall")
                                   collect  (cons (format "%s"  cand) cand)))

(defvar helm-mpd-key-map
  (let ((map (make-sparse-keymap)))
    (set-keymap-parent map helm-map) map))

(defvar helm-mpd-actions (helm-make-actions '("play" .
                                              (lambda (i) (let ((file-name  (car (cdr i))))
                                                            (message (format "%s %s" (type-of file-name) file-name))
                                                            (mpd-enqueue mpd-conn file-name))))))

(setq helm-mpd-song-source
      (helm-build-sync-source "mpd songs"
        :keymap helm-mpd-key-map
        :candidates #'helm-mpd-all-songs
        :persistent-action helm-mpd-actions
        ;;:filtered-candidate-transformer #'h-candidate-transformer
        ;;:action-transformer #'h-action-transformer
        ))

(defun helm-mpd ()
  (interactive)
  (helm :sources 'helm-mpd-song-source))


;; as described here: http://kitchingroup.cheme.cmu.edu/blog/2016/01/24/Modern-use-of-helm-sortable-candidates/
;; (setq h-source
;;       (helm-build-sync-source "number-selector"
;;         :keymap h-map
;;         :candidates #'h-candidates
;;         :filtered-candidate-transformer #'h-candidate-transformer
;;         :action-transformer #'h-action-transformer))

;; (helm :sources 'h-source)


                                        ;
;; search artist album song title from playlist or library

;;; helm-mpd.el ends here
