(asdf:defsystem "slregex"
  :version "0.0.1"
  :author "Lihui Zhang"
  :mailto "zlihui@gmail.com"
  :license "MIT"
  :depends-on ("str")
  :components ((:module "src"
                :components
                ((:file "main"))))
  :description "A simple regex library for fun"
  :in-order-to ((test-op (test-op "slregex/tests"))))

(asdf:defsystem "slregex/tests"
  :author "Lihui Zhang"
  :license ""
  :depends-on ("slregex"
               "rove")
  :components ((:module "tests"
                :components
                ((:file "main"))))
  :description "Test system for slregex"
  :perform (test-op (op c) (symbol-call :rove :run c)))
