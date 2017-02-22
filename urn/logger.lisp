(import string)
(import lua/math math)

(define verbosity (struct :value 0))
(defun set-verbosity! (level) (.<! verbosity :value level))

(define show-explain (struct :value false))
(defun set-explain! (value) (.<! show-explain :value value))

;; Color a string using ANSI escape codes
(defun colored (col msg) (string/.. "\27[" col "m" msg "\27[0m"))

;; Print an error message
(defun print-error! (msg)
  (with (lines (string/split msg "\n" 1))
    (print! (colored 31 (string/.. "[ERROR] " (car lines))))
    (when (cadr lines) (print! (cadr lines)))))

;; Print a warning message
(defun print-warning! (msg)
  (with (lines (string/split msg "\n" 1))
    (print! (colored 33 (string/.. "[WARN] " (car lines))))
    (when (cadr lines) (print! (cadr lines)))))

;; Print a verbose message
(defun print-verbose! (msg)
  (when (> (.> verbosity :value) 0)
    (print! (string/.. "[VERBOSE] " msg))))

;; Print a debug message
(defun print-debug! (msg)
  (when (> (.> verbosity :value) 1)
    (print! (string/.. "[DEBUG] " msg))))

;; Format a position to be user-readable
(defun format-position (pos)
  (string/.. (.> pos :line) ":" (.> pos :column)))

;; Format a range to be user-readable
(defun format-range (range)
  (if (.> range :finish)
    (string/format "%s:[%s .. %s]" (.> range :name) (format-position (.> range :start)) (format-position (.> range :finish)))
    (string/format "%s:[%s]" (.> range :name) (format-position (.> range :start)))))

(defun format-node (node) (cond
  ((and (.> node :range) (.> node :contents))
    (string/format "%s (%q)" (format-range (.> node :range)) (.> node :contents)))
  ((.> node :range) (format-range (.> node :range)))
  ((.> node :macro)
    (with (macro (.> node :macro))
      (string/format "macro expansion of %s (%s)"
        (.> macro :var :name)
        (format-node (.> macro :node)))))
  ((and (.> node :start) (.> node :finish))
    (format-range node))
  (true "?")))

(defun get-source (node)
  (with (result nil)
    (while (and node (! result))
      (set! result (.> node :range))
      (set! node (.> node :parent)))
    result))

(defun put-lines! (range &entries)
  (when (nil? entries) (error! "Positions cannot be empty"))
  (when (/= (% (# entries) 2) 0) (error! (string/.. "Positions must be a multiple of 2, is " (# entries))))

  (let* ((previous -1)
         (file (.> (nth entries 1) :name))
         (max-line (foldr (lambda (node max)
                            (if (string? node) max (math/max max (.> node :start :line))))
                     0 entries))
         (code (string/.. "\27[92m %" (string/#s (number->string max-line)) "s |\27[0m %s")))
    (for i 1 (# entries) 2
      (let ((position (.> entries i))
            (message (.> entries (succ i))))

        (cond
          ;; If we're in a different file then print the new file name
          ((/= file (.> position :name))
            (set! file (.> position :name))
            (print! (.. "\27[95m " file "\27[0m")))
          ;; If we've got a gap in the lines then print a ...
          ((and (/= previous -1) (> (math/abs (- (.> position :start :line) previous)) 2))
            (print! " \27[92m...\27[0m"))
          (true))
        (set! previous (.> position :start :line))

        ; Write the current line
        (print! (string/format code
          (number->string (.> position :start :line))
          (.> position :lines (.> position :start :line))))

        ; Write a pointer to the current line
        (with (pointer
          (cond
            ((! range) "^")
            ((and (.> position :finish) (= (.> position :start :line) (.> position :finish :line)))
              (string/rep "^" (succ (- (.> position :finish :column) (.> position :start :column)))))
            (true "^...")))

          (print! (string/format code "" (string/..
            (string/rep " " (- (.> position :start :column) 1))
            pointer
            " "
            message))))))))

(defun put-trace! (node)
  (with (previous nil)
    (while node
      (with (formatted (format-node node))
        (cond
          ((= previous nil) (print! (colored 96 (string/.. "  => " formatted))))
          ((/= previous formatted) (print! (string/.. "  in " formatted)))
          (true nil))

        (set! previous formatted)
        (set! node (.> node :parent))))))

(defun put-explain! (&lines)
  (when (.> show-explain :value)
    (for-each line lines
      (print! (string/.. "  " line)))))

(defun put-error! (node msg)
  (print-error! msg)
  (put-trace! node)

  (with (source (get-source node))
    (when source (put-lines! true source ""))))

(defun error-positions! (node msg)
  (print-error! msg)
  (put-trace! node)

  (with (source (get-source node))
    (when source (put-lines! true source "")))

  (fail! "An error occured"))

(struct
  :colored        colored

  :formatPosition format-position
  :formatRange    format-range
  :formatNode     format-node

  :putLines       put-lines!
  :putTrace       put-trace!
  :putInfo        put-explain!
  :getSource      get-source

  :printWarning   print-warning!
  :printError     print-error!
  :printVerbose   print-verbose!
  :printDebug     print-debug!

  :errorPositions error-positions!

  :setVerbosity   set-verbosity!
  :setExplain     set-explain!
)
