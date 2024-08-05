(defpackage slregex
  (:use :cl :str :iterate :alexandria)
  (:export #:compile-regex #:match-regex))
(in-package :slregex)

(defclass regex ()
    ((kind
      :initarg :kind
      :accessor kind)
     (ch
      :initarg :ch
      :accessor ch)))

(defun compile-regex (pattern &optional result)
  (cond
    ((string= pattern "") result)
    (t (switch ((s-first pattern) :test string=)
	 ("^" (compile-regex (s-rest pattern) (push (make-instance 'regex :kind :start) result)))
	 ("$" (compile-regex (s-rest pattern) (push (make-instance 'regex :kind :end) result)))
	 ("." (compile-regex (s-rest pattern) (push (make-instance 'regex :kind :dot) result)))
	 ("*" (compile-regex (s-rest pattern) (push (make-instance 'regex :kind :star) result)))
	 ("+" (compile-regex (s-rest pattern) (push (make-instance 'regex :kind :plus) result)))
	 ("?" (compile-regex (s-rest pattern) (push (make-instance 'regex :kind :optional) result)))
	 ("|" (compile-regex (s-rest pattern) (push (make-instance 'regex :kind :alternation) result)))
	 (otherwise (compile-regex (s-rest pattern) (push (make-instance 'regex :kind :character :ch (s-first pattern)) result)))))))

(defun is-kind (pattern kind)
  (= (car pattern) kind))

(defun match-regex (pattern text)
  (cond
    ((null pattern) (emptyp text))
    ((is-kind pattern :start))
    (t (match-regex (cdr pattern) (s-rest text))))

(defun match--star ()))
