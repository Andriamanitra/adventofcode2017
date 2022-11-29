(def input
    (->> (slurp "22-input.txt")
        (string/trim)
        (string/split "\n")))

(def num-rows (length input))
(def num-cols (length (first input)))

(def infected @{})
(var counter 0)

(for r 0 num-rows
    (for c 0 num-cols
        (if (= (get (get input r) c) 35)
            (put infected [r c] true))))

(def virus 
    (let [row (/ (- num-rows 1) 2)
          col (/ (- num-cols 1) 2)]
        @{:facing :up
         :pos [row col]}))

(defn infected? (pos)
    (get infected pos))

(defn turn-left (virus)
    (put virus :facing
        (case (virus :facing)
            :up :left
            :right :up
            :down :right
            :left :down)))

(defn turn-right (virus)
    (put virus :facing
        (case (virus :facing)
            :up :right
            :right :down
            :down :left
            :left :up)))

(defn walk (virus)
    (let [[r c] (virus :pos)]
        (put virus :pos
            (case (virus :facing)
                :up    [(- r 1) c]
                :right [r (+ c 1)]
                :down  [(+ r 1) c]
                :left  [r (- c 1)]))))

(defn burst (virus infected)
    (if (infected? (virus :pos))
        (do
            (turn-right virus)
            (put infected (virus :pos) nil))
        (do
            (turn-left virus)
            (++ counter)
            (put infected (virus :pos) true)))
    (walk virus))

(for i 0 10000
    (burst virus infected))

(pp counter)
