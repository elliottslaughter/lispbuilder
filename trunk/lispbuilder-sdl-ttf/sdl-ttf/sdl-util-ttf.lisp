;; This file contains some useful functions for using SDL_ttf from Common lisp
;; 2006 (c) Rune Nesheim, see LICENCE.
;; 2007 (c) Luke Crook

(in-package #:lispbuilder-sdl-ttf)

;;; Add INIT-TTF to LISPBUILDER-SDL's external initialization list.
;;; Functions in this list are called within the macro SDL:WITH-INIT, and the function SDL:INIT-SDL 
(pushnew 'init-ttf sdl:*external-init-subsystems-on-startup*)

;;; Add the QUIT-TTF to LISPBUILDER-SDL's external uninitialization list.
;;; Functions in this list are called when the macro SDL:WITH-INIT exits, and the function SDL:QUIT-SDL 
(pushnew 'quit-ttf sdl:*external-quit-subsystems-on-exit*)

(defun is-init ()
  "Queries the initialization status of the `SDL_TTF` truetype library. 
Returns the current *GENERATION* if this library is already initialized and `NIL` if uninitialized."
  (if (sdl-ttf-cffi::ttf-was-init)
      *generation*
      nil))

;;; Functions

(defun init-ttf ()
  "Initializes the `SDL_TTF` font library if uninitialized. Increments and returns *GENERATION* if the library 
was uninitialized and is successfully initialized, or else returns `NIL` if uninitialized."
  (if (is-init)
      *generation*
      (progn
	(if (sdl-ttf-cffi::ttf-init)
	    (incf *generation*)
	    nil))))

(defun quit-ttf ()
  "Uninitializes the `SDL_TTF` font library if already initialized."
  (if (is-init)
      (sdl-ttf-cffi::ttf-quit)))
