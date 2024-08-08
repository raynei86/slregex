(defpackage slregex
  (:use :cl :str :iterate :alexandria))
(in-package :slregex)


(defclass fragment ()
  ((outs
    :initarg :outs
    :accessor outs
    :initform '())
   (transitions
    :initarg :transitions
    :accessor transitions
    :initform '())
   (is-end
    :initarg :is-end
    :accessor is-end)
   (is-split
    :initarg :is-split
    :accessor is-split)))

(defclass nfa ()
  ((start
    :initarg :start
    :accessor start)
   (end
    :initarg :end
    :accessor end)
   (fragments
    :initarg :fragments
    :accessor fragments)
   (transitions
    :initarg :transitions
    :accessor transitions)))

(defun make-epsilon (from to)
  (push to (outs from))
  (push :eps (transitions from))
  to)

(defun make-transitions (from to ch)
  (push to (outs from))
  (push ch (transitions from))
  to)

(defun match--transition (string transition-state transition-char)
  (cond
    ((string= (s-first string) transition-char)
     (run-nfa transition-state (s-rest string)))
    ((eql transition-char :eps)
     (run-nfa transition-state string))
    (t nil)))

(defun run-nfa (nfa string)
  (let* ((outs (outs nfa))
	 (transitions (transitions nfa))
	 (out1 (first outs))
	 (out2 (second outs))
	 (trans1 (first transitions))
	 (trans2 (second transitions)))
    (cond
      ((emptyp string) (is-end nfa))
      ((null nfa) nil)
      ((is-split nfa)
       (or
	(match--transition string out1 trans1)
	(match--transition string out2 trans2)))
      (t (match--transition string out1 trans1)))))
