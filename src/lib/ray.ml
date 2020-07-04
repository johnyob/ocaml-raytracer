type t = Point.t * Vector.t

let make origin direction = (origin, Vector.normalize direction)

let origin (origin, _) = origin
let direction (_, direction) = direction

let at (origin, direction) t = 
  let open Vector in
  origin ^+^ (t *^ direction)