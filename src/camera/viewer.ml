type t = { eye: Point.t; n: Vector.t; u: Vector.t; v: Vector.t }

let make ~eye ~at ~up = 
  let open Vector in
  let n = normalize (eye ^-^ at) in
  let u = normalize (up ^*^ n) in
  { eye; n; u; v=n ^*^ u}