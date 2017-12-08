(use '[clojure.string :only (join split trim-newline)])
(def data (slurp "8-input.txt"))
(def lines (mapv #(trim-newline %) (split data #"\n")))

(defn compute-one [varmap instr]
  (let [operator (clojure.string/replace (instr 5) #"!" "not")
        left-operand (get varmap (instr 4) 0)
        right-operand (read-string (instr 6))
        operation (join " " ["(" operator left-operand right-operand ")"])
        increment (read-string (instr 2))]
    (if (eval (read-string operation))
      (if (= (instr 1) "inc")
        (assoc varmap (instr 0) (+ (get varmap (instr 0) 0) increment))
        (assoc varmap (instr 0) (- (get varmap (instr 0) 0) increment)))
      varmap)))

(defn compute [varmap instructions current-max]
  (let [new-max (if (> (count varmap) 0) (apply max (vals varmap)) 0)] 
    (if (= (count instructions) 0)
      current-max 
      (compute (compute-one varmap (first instructions))
               (rest instructions)
               (if (< current-max new-max) new-max current-max)))))

(let [instructions (mapv #(split % #" ") lines)
      varmap-max (compute {} instructions 0)]
  (println "Maximum value was" varmap-max))
