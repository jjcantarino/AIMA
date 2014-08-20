; M+j - new comment line. Aweomse =)
; Goal: Simulate environment with vacuum-cleaner agent in it
(import time)

; >>>> Agent class <<<<
(defclass agent [object]
  [[--init--
    (fn [self]
      (setv self.location [0 0])
      (setv self.state 1) ; 0 means do nothing, 1 means clean cell
      (setv self.direction 2) ; 1 : N
                              ; 2 : E
                              ; 3 : S
                              ; 4 : W
      None)]

   [act
    (fn [self]
      ; Sensors. If current cell is dirty - clean it.
    (if (get env
             (get (.getLocation self) 1)
             (get (.getLocation self) 0)
             "dirty")
      (setv self.state 1); Clean
      (setv self.state 0)); Stop cleaning.
    (if (= self.direction 2) ; If direction is east
      (if (= (.moveEast self) "bump") ; Move 1 step east
        (setv self.direction 4)) ; turn 180 if bump into wall
      (if (= (.moveWest self) "bump")
        (setv self.direction 2)))
      )]


   [moveEast
    (fn [self]
      (if (< (get self.location 0) (- (len (get env 0)) 1))
        (setv (get self.location 0)  (+ (get self.location 0) 1)) ; 1 step east
        "bump"
        ))]

   [moveWest
    (fn [self]
      (if (> (get self.location 0) 0)
        (setv (get self.location 0)  (- (get self.location 0) 1)) ; 1 step west
        "bump"
        ))]

   [moveNorth
    (fn [self]
    (setv (get self.location 0)  (- (get self.location 1) 1)))]

   [moveSouth
    (fn [self]
    (setv (get self.location 0)  (+ (get self.location 1) 1)))]

   
   [cleanDirt
    (fn [self]
    (setv self.state 1))]

   [dontCleanDirt
    (fn [self]
    (setv self.state 0))]      

   [getLocation
    (fn [self]
      self.location)]
   
   [getState
    (fn [self]
      self.state)]])

; >>>> Create environment ****
(defn createEnv[gridSizeX gridSizeY]
  ;; Create grid
  (defn createGrid[gridSizeX gridSizeY]
    (setv grid [])
    (setv i 1)
    (for (y (range gridSizeY))
      (setv row [])
      (for (x (range gridSizeX))

        (print y x )
           (setv cell {"num" i "dirty" 1})
           (setv i (+ i 1))
           (.append row cell))
      (.append grid row))
    grid)
  (setv env (createGrid gridSizeX gridSizeY))
  env
  )


; >>>> Redraw environment ****
(defn redrawEnv[env agent]
  ; Choose cell icon.
  ; [*] - cell is dirty
  ; [ ] - cell is empty  
  ; [R] - robot is in the cell
  ; [^] - robot cleans dirt.
  (defn cellIcon[row cell]
    ; Does agent clean dirt?
    (defn agentIcon[]
      (if (= (.getState agent) 0)
        "R"
        "^"
        ))
    ; Is agent in this cell?
    (setv agentIsHere 0)
    (if (= (get (.getLocation agent) 0) cell)
      (if (= (get (.getLocation agent) 1) row)
        (setv agentIsHere 1)))
    ; If agent is here show his icon, otherwise - show dirty or empty cell.
    (if (= agentIsHere 1)
      (agentIcon)
      (if (= (get env row cell "dirty") 1)
        "*"
        " ")))
  
  ; Clean screen
  (print (* "\n" 32))
  
  ; Draw environment
  (for (row (range (len env))) ; hack to iterate through list. "for row in env"
    (setv rowToPrint "")
    (for (cell (range (len (get env row)))) ; "for cell in row"
      (setv rowToPrint (+  rowToPrint ; hack around to print on the same line
                           "["
                           ;(.zfill (str(get env row cell "num")) 2) ;print cell number
                           (cellIcon row cell)
                           "]")))
    (print rowToPrint)))


; >>>> Run simulation ****
(defn runSimulation[timesteps]
  ; Create env and agent
  (setv env (createEnv 4 4))
  (setv cleaner (agent))
  
  ; Simulate agent cleaning grid  
  (defn simulateCleaning[] 
    (if (and (= (get env
                  (get (.getLocation cleaner) 1)
                  (get (.getLocation cleaner) 0)
                  "dirty") 1)
             (= (.getState cleaner) 1)) ; If cell is dirty and agent is cleaning.
      (setv (get env
                 (get (.getLocation cleaner) 1)
                 (get (.getLocation cleaner) 0)
                 "dirty") 0))) ; Clean the cell

  ; One simulation step
  (defn step[]
    (redrawEnv env cleaner)
    (.act cleaner)
    (simulateCleaning)
    (.sleep time 0.5))

  ; Run
  (for (s (range 10))
    (step)))
(runSimulation 4)


