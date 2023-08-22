#lang racket

(require data/heap)

(struct slot (vec pos) #:transparent)

(define (graphviz port open closed)
  (unless (set-empty? open)
    (define v (set-first open))
    (set-remove! open v)
    (set-add! closed v)
    (for ([i (in-naturals)] [s v] #:when s)
      (define w (slot-vec s))
      (when (<= (equal-always-hash-code (slot v i)) (equal-always-hash-code s))
        (fprintf port "~a -- ~a;\n" (equal-always-hash-code v) (equal-always-hash-code w)))
      (unless (set-member? closed w) (set-add! open w)))
    (graphviz port open closed)))

(define open-slots
  (make-heap (lambda (x y) (<= (equal-always-hash-code x)
                               (equal-always-hash-code y)))))

(define (new n)
  (define v (make-vector n #f))
  (for ([i n])
    (heap-add! open-slots (slot v i)))
  (slot v 0))

(define (remove-open-slot s)
  (if (zero? (heap-count open-slots))
      #f
      (let ([t (heap-min open-slots)])
        (heap-remove-min! open-slots)
        (if (or (equal? s t)
                (vector-ref (slot-vec t) (slot-pos t)))
            (remove-open-slot s)
            t))))

(define (go s)
  (let* ([vec (slot-vec s)]
         [pos (slot-pos s)]
         [n (vector-length vec)]
         [pos (modulo (+ pos 1 (random (- n 1))) n)])
    (call-with-atomic-output-file "/tmp/scramble.gv"
      ; xdot -f neato /tmp/scramble.gv
      (lambda (port path)
        (fprintf port "graph scramble {\n")
        (fprintf port "node [shape=point];\n")
        (graphviz port (mutable-seteq vec) (mutable-seteq))
        (fprintf port "}\n")))
    (let loop ()
      (unless (zero? (heap-count open-slots))
        (let ([t (heap-min open-slots)])
          (when (vector-ref (slot-vec t) (slot-pos t))
            (heap-remove-min! open-slots)
            (loop)))))
    (unless (zero? (heap-count open-slots))
      (go (or (vector-ref vec pos)
              (let* ([s (slot vec pos)]
                     [t (or (and (zero? (random 4))
                                 (remove-open-slot s))
                            (new 3))])
                (vector-set! vec pos t)
                (vector-set! (slot-vec t) (slot-pos t) s)
                t))))))

(go (new 3))
