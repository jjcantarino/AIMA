(setv X '[WA, NT, Q, NSW, V, SA, T]) ;define variables
(setv D '[red, green, blue]) ;define domains(possible values for vars)
;(.find x 'b);/or .index
(import [PIL [Image ImageDraw]])
(import random)
(import [random [randint]])
(import [math [hypot]])


(defn makePolygons[]
  (defn scatterPoints[]
    (setv points [])
    (for (x (range 16))
      (setv point [])
      (random.seed x)
      (.append point (random.randint 1 400))      
      (random.seed (+ x 100))
      (.append point (random.randint 1 400))
      (.append points point))
    points)

  (setv points (scatterPoints))

  (defn findClosestPoint[currentPoint listOfPoints]
    (setv currentPointPosX (get currentPoint 0))
    (setv currentPointPosY (get currentPoint 1))
    
    (setv closestPoint [])
    (setv minDistance 1000)

    (setv restOfThePoints listOfPoints)
    ;(if [currentPoint restOfThePoints] (.remove restOfThePoints currentPoint))    

    (for [p restOfThePoints]
      (setv pPosX (get p 0))
      (setv pPosY (get p 1))
      (setv distance (hypot (- pPosX currentPointPosX)
                            (- pPosY currentPointPosY)))
      (print distance)
      (if (and (< distance minDistance) (> distance 0))
        (do
         (setv closestPoint p)
         (setv minDistance distance))))
    (print closestPoint)
    closestPoint)

  (defn drawGrid[]
    ;create image
    (setv im (Image.new "RGBA" [400 400] (, 64 64 64 0)))
    (setv draw (ImageDraw.Draw im))

    ;for each point
    (for [currentPoint points]
      (setv currentPointPosX (get currentPoint 0))
      (setv currentPointPosY (get currentPoint 1))      
      (setv rad 3)
      (if (= currentPoint (get points 15))
        (setv rad 8))

      ;draw circle around point
      (draw.ellipse [(-  currentPointPosX rad) (- currentPointPosY rad)
                     (+  currentPointPosX rad) (+ currentPointPosY rad)])

      (setv pointsToIterate points)
      (for [p pointsToIterate]
        
        ;find closest point
        (setv closestPoint (findClosestPoint p points))
        
        ;draw line to closest point
        (setv closestPointPosX (get closestPoint 0))
        (setv closestPointPosY (get closestPoint 1))      
        (draw.line [currentPointPosX currentPointPosY
                    closestPointPosX closestPointPosY]
                   (, 0 256 0) 1)))
    (.show im))
  (drawGrid))
(makePolygons)


