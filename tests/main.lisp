(defpackage slregex/tests/main
  (:use :cl
        :slregex
        :rove))
(in-package :slregex/tests/main)

;; NOTE: To run this test file, execute `(asdf:test-system :slregex)' in your Lisp.

(deftest test-target-1
  (testing "should (= 1 1) to be true"
    (ok (= 1 1))))
