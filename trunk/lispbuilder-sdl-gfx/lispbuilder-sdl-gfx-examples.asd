;;; -*- lisp -*-

(defpackage :lispbuilder-sdl-gfx-examples-system
  (:use :common-lisp :asdf :cffi))
(in-package :lispbuilder-sdl-gfx-examples-system)

(defsystem lispbuilder-sdl-gfx-examples
    :description "Examples describing the use of lispbuilder-sdl-gfx."
    :depends-on (cffi lispbuilder-sdl lispbuilder-sdl-gfx)
    :components
    ((:module "examples"
	      :components
	      ((:doc-file "README")
	       (:file "package")
	       (:file "font" :depends-on ("package"))
	       (:file "random_circles" :depends-on ("package"))))))
