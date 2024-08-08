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
      :accessor ch)
     ))

(defmethod print-object ((obj regex) stream)
  (print-unreadable-object (obj stream :type t)
    (format stream "kind: ~a, char: ~a" (kind obj) (if (eql (kind obj) :character) (ch obj) ""))))

(defun compile-regex (pattern &optional result)
  (cond
    ((string= pattern "") (reverse result))
    (t (switch ((s-first pattern) :test string=)
	 ("^" (compile-regex (s-rest pattern) (cons (make-instance 'regex :kind :start :ch "^") result)))
	 ("$" (compile-regex (s-rest pattern) (cons (make-instance 'regex :kind :end :ch "$") result)))
	 ("." (compile-regex (s-rest pattern) (cons (make-instance 'regex :kind :dot :ch ".") result)))
	 ("*" (compile-regex (s-rest pattern) (cons (make-instance 'regex :kind :star :ch "*") result)))
	 ("+" (compile-regex (s-rest pattern) (cons (make-instance 'regex :kind :plus :ch "+") result)))
	 ("?" (compile-regex (s-rest pattern) (cons (make-instance 'regex :kind :optional :ch "?") result)))
	 ("|" (compile-regex (s-rest pattern) (cons (make-instance 'regex :kind :alternation :ch "|") result)))
	 (otherwise (compile-regex (s-rest pattern) (cons (make-instance 'regex :kind :character :ch (s-first pattern)) result)))))))

(defun is-kind (regex kind)
  (eql (kind regex) kind))

(defun match-regex (regex text)
  (switch ((car regex) :test #'is-kind)
    (:character (string= (ch (car regex)) (s-first text)))
    (t (match-regex (cdr regex) (s-rest text)))))

(defun match--here (regex text)
  (cond
    ((null regex) t)
    ((and (is-kind (car regex) :end) (null (cdr regex)))
     (emptyp text))
    ((and text (or
		(is-kind (car regex) :dot)
		(string= (ch (car regex)) (s-first text))))
     (match--here (cdr regex) (s-rest text)))
    (t nil)))

(defun match--star (current regex text)
  (let ((first-char (s-first text)))
      (cond
	((emptyp text) nil)
	((or (string= first-char (ch regex)) (string= first-char current))
	 (match--here regex text))
	(t nil))))
