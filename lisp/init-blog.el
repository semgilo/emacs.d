(require-package 'ox-hugo)

(with-eval-after-load 'ox
  (require 'ox-hugo))


;; Populates only the EXPORT_FILE_NAME property in the inserted headline.
(with-eval-after-load 'org-capture
  (defun org-hugo-new-subtree-post-capture-template ()
    "Returns `org-capture' template string for new Hugo post.
See `org-capture-templates' for more information."
    (let* ((title (read-from-minibuffer "Post Title: ")) ;Prompt to enter the post title
           (fname (org-hugo-slug title)))
      (mapconcat #'identity
                 `(
                   ,(concat "* TODO " title)
                   ":PROPERTIES:"
                   ,(concat ":EXPORT_FILE_NAME: " fname)
                   ":END:"
                   "%?\n")          ;Place the cursor here finally
                 "\n")))

  (add-to-list 'org-capture-templates
               '("h"                ;`org-capture' binding + h
                 "Hugo post"
                 entry
                 ;; It is assumed that below file is present in `org-directory'
                 ;; and that it has a "Blog Ideas" heading. It can even be a
                 ;; symlink pointing to the actual location of all-posts.org!
                 (file+olp "~/Documents/git/gtd/all-posts.org" "Blog Ideas")
                 (function org-hugo-new-subtree-post-capture-template))))

(defun write-blog ()
  (interactive)
  (hexo "~/Documents/Github/www.lanhuzi.com/"))


(defun semgilo/insert-org-img-link (prefix imagename)
  (if (equal (file-name-extension (buffer-file-name)) "org")
      (insert (format "[[%s][%s%s]]" imagename prefix imagename))
    (insert (format "![%s](%s%s)" imagename prefix imagename))))

(defun semgilo/capture-screenshot (basename)
  "Take a screenshot into a time stamped unique-named file in the
  same directory as the org-buffer/markdown-buffer and insert a link to this file."
  (interactive "sScreenshot name: ")
  (if (equal basename "")
      (setq basename (format-time-string "%Y%m%d_%H%M%S")))
  (setq fullpath
        (concat (file-name-directory (buffer-file-name))
                "../images/posts/"
                (file-name-base (buffer-file-name))
                "_"
                basename))
  (setq relativepath
        (concat (file-name-base (buffer-file-name))
                "_"
                basename
                ".png"))

  (if (file-exists-p (file-name-directory fullpath))
      (progn
        (call-process "screencapture" nil nil nil "-s" (concat fullpath ".png"))
        (semgilo/insert-org-img-link "https://www.lanhuzi.com/img/" relativepath))
    (progn
      (call-process "screencapture" nil nil nil "-s" (concat basename ".png"))
      (semgilo/insert-org-img-link "./" (concat basename ".png"))))
  (insert "\n"))

(defun semgilo/record-screencapture (basename)
  "Take a screenshot into a time stamped unique-named file in the
  same directory as the org-buffer/markdown-buffer and insert a link to this file."
  (interactive "sScreenshot name: ")
  (call-process "/Applications/LICPcap.app" nil 0)
  )
  
(global-set-key [C-s-268632065] 'semgilo/capture-screenshot)

(provide 'init-blog)
