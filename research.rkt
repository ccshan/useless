#lang racket
(define research (mutable-set 0))
(for ([x research])
  (set-remove! research x)
  (println x)
  (set-add! research (+ x (random -1 2)))
  (set-add! research (+ x (random -1 2))))
