;;;; (C) 2006 Jonathan Heusser, minor changes by Frank Buss

(in-package #:lispbuilder-sdl-examples)

(defvar *image-path* (or *load-truename* *default-pathname-defaults*))
			     
(defun in-range (p1 p2 distance)
  "return true, if the distance between p1 and p2 is not more than 'distance'"
  (<= (+ (expt (- (sdl:point-x p1) (sdl:point-x p2)) 2)
         (expt (- (sdl:point-y p1) (sdl:point-y p2)) 2))
      (expt distance 2)))

(defun make-random-point ()
  (sdl:point (random 630) (random 470)))

(defun show-score (score)
  (sdl:WM_SetCaption (format nil "Squashed - Score: ~a" score) "Squashed"))

(defun squashed ()
  "Squashed: main entry function"
  (sdl:with-init ()
    (sdl:with-display (640 480)
      (let ((bug-point (make-random-point))
	    (racket-point (sdl:point 100 100))
	    (squashed-point nil)
	    (levelticks 1000)
	    (last-squash-tick 0)
	    (lasttick 0)
	    (score 0))
	(sdl:with-surfaces ((bug (sdl:load-image "bug.bmp" *image-path* :key-color #(255 255 255)))
			    (racket (sdl:load-image "racket.bmp" *image-path* :key-color #(255 255 255)))
			    (blood (sdl:load-image "blood.bmp" *image-path* :key-color #(255 255 255)))
			    (squash (sdl:load-image "squash.bmp" *image-path* :key-color #(255 255 255))))
	  (show-score score)
	  (sdl:display-cursor nil)
	  (sdl:with-events
	    (:quit t)
	    (:mousemotion (state x y xrel yrel)
			  (setf (sdl:point-x racket-point) x
				(sdl:point-y racket-point) y))
	    (:mousebuttondown (button state x y)
			      ;; check if squashed
			      (when (in-range racket-point bug-point 17)
				(setf squashed-point (sdl:point x y)
				      last-squash-tick (sdl:SDL_GetTicks))
				(show-score (incf score))
				:     ; increase the bug jumping speed
				(when (> levelticks 200)
				  (decf levelticks 100))))
	    (:idle
	     ;; fill the background white
	     (sdl:clear-screen #(255 255 255))
	     ;; draw images
	     (when squashed-point
	       (sdl:draw-image squashed-point blood))
	     (when (> (sdl:SDL_GetTicks) (+ lasttick levelticks))
	       (setf lasttick (sdl:SDL_GetTicks)
		     bug-point (make-random-point)))
	     (if (< (- (sdl:SDL_GetTicks) last-squash-tick) 500)
		 (sdl:draw-image (sdl:point 0 0) squash)
		 (sdl:draw-image bug-point bug))
	     (sdl:draw-image racket-point racket)
	     ;; blit to screen
	     (sdl:update-screen))))))))
