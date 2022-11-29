(def input
    (->> (slurp "22-input.txt")
        (string/trim)
        (string/split "\n")))

(def num-rows (length input))
(def num-cols (length (first input)))

(def CLEAN 0)
(def WEAKENED 1)
(def INFECTED 2)
(def FLAGGED 3)

(def nodes @{})
(var counter 0)

(for r 0 num-rows
    (for c 0 num-cols
        (if (= (get (get input r) c) 35)
            (put nodes [r c] INFECTED))))

(def virus 
    (let [row (/ (- num-rows 1) 2)
          col (/ (- num-cols 1) 2)]
        @{:facing :up
         :pos [row col]}))

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

(defn burst (virus nodes)
    (let [pos (virus :pos)
          state (or (get nodes pos) CLEAN)]
        (case (get nodes pos)
            WEAKENED (do
                (++ counter))
            FLAGGED (do
                (turn-right virus)
                (turn-right virus))
            INFECTED (do
                (turn-right virus)
                (put nodes (virus :pos) nil))
            # default: CLEAN or nil
            (turn-left virus))
        (put nodes pos (% (+ state 1) 4)))
    (walk virus))

(for i 0 10_000_000
    (burst virus nodes))

(pp counter)
