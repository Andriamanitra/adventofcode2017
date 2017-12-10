;; indentations and stuff are all over the place in this file, deal with it
;; 8-2.clj should be better

(use '[clojure.string :only (join split trim-newline)])
(def data (slurp "08-input.txt"))
(def lines (mapv #(trim-newline %) (split data #"\n")))

(defn compute-one [varmap instr]
    (if (eval (read-string (join " " ["(" (clojure.string/replace (instr 5) #"!" "not") (get varmap (instr 4) 0) (read-string (instr 6)) ")"])))
        (if (= (instr 1) "inc")
            (assoc varmap (instr 0) (+ (get varmap (instr 0) 0) (read-string (instr 2))))
            (assoc varmap (instr 0) (- (get varmap (instr 0) 0) (read-string (instr 2)))))
        varmap))

(defn compute [varmap instructions]
    (if (= (count instructions) 0) varmap (compute (compute-one varmap (first instructions)) (rest instructions))))

(let [instructions (mapv #(split % #" ") lines)]
    (let [varmap (compute {} instructions)
        varmap-max (apply max-key val varmap)]
    (println (join "" ["Maximum value is " (key varmap-max) ": " (val varmap-max)]))))
