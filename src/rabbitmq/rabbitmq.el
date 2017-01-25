(require 'ox-publish)
(setq org-publish-project-alist
      '(
        ;; These are the main web files
        ("rabbitmq-notes"
         :base-directory "~/Documents/programming/html/klose911.github.io/src/rabbitmq" 
         :base-extension "org"
         :publishing-directory "~/Documents/programming/html/klose911.github.io/html/rabbitmq"
         :recursive t
         :publishing-function org-html-publish-to-html
         :headline-levels 4
         :auto-sitemap nil
	 :section-numbers nil
         ;; :with-toc nil
         :html-head "<link rel=\"stylesheet\"
                       href=\"css/main.css\" type=\"text/css\"/>"
         :html-preamble t
	 :html-postamble klose-html-postamble
	 :htmlized-source t
         )

        ;; These are static files (images, pdf, etc)
        ("rabbitmq-static"
         :base-directory "~/Documents/programming/html/klose911.github.io/src/css" ;; Change this to your local dir
         :base-extension "css"
         :publishing-directory "~/Documents/programming/html/klose911.github.io/html/rabbitmq/css"
         :recursive t
         :publishing-function org-publish-attachment
         )
	;; picture
        ("rabbitmq-pic"
         :base-directory "~/Documents/programming/html/klose911.github.io/src/rabbitmq/pic"  ;; Change this to your local dir
         :base-extension "png\\|jpg\\|gif"
         :publishing-directory "~/Documents/programming/html/klose911.github.io/html/rabbitmq/pic"
         :recursive t
         :publishing-function org-publish-attachment
         )
	
        ("rabbitmq" :components ("rabbitmq-notes" "rabbitmq-static" "rabbitmq-pic"))
        )
      )

(defun rabbitmq-publish (no-cache)
  "Publish rabbitmq"
  (interactive "sno-cache?[y/n] ")
  (if (or (string= no-cache "y")
          (string= no-cache "Y"))
      (org-publish "rabbitmq" t)
    (org-publish "rabbitmq" nil)))
