(use '[clojure.string :only (join split trim-newline)])
(def data (slurp "08-input.txt"))
(def lines (mapv #(trim-newline %) (split data #"\n")))
(def operator-map {"!=" not= "==" = "<=" <= ">=" >= ">" > "<" <})

(defn compute-one [varmap instr]
  (let [operator (get operator-map (instr 5))
        left-operand (get varmap (instr 4) 0)
        right-operand (read-string (instr 6))
        increment (read-string (instr 2))]
    (if (operator left-operand right-operand)
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
