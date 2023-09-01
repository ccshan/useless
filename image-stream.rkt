#lang racket
; Enumerate all images

(require data/enumerate/lib)
(require 2htdp/image)
(require 2htdp/universe)

(define byte/e
  (append/e (cons (single/e 0) zero?)
            (cons (pam/e cdr
                         #:contract exact?
                         (dep/e natural/e
                                (λ (bits) (pam/e (λ (n) (* (expt 2 (- 7 bits)) (+ 1 (* 2 n))))
                                                 #:contract exact?
                                                 (below/e (expt 2 bits))))
                                #:f-range-finite? #t
                                #:one-way? #t))
                  positive?)))

(define (fix n)
  (max 1 (min 255 (round n))))

(define solid/e
  (pam/e (lambda (r g b) (square 256 "solid" (make-color (fix r) (fix g) (fix b))))
         #:contract image?
         byte/e byte/e byte/e))

(define image/e
  (or/e solid/e
        (delay/e (pam/e (lambda (i j k l)
                          (scale 1/2 (above (beside i j) (beside k l))))
                        #:contract image?
                        image/e image/e image/e image/e)
                 #:flat-enum? #t
                 #:two-way-enum? #f)))

(animate (λ (n) (from-nat image/e n)))