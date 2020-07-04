open Base
type t = float * float * float

(* Color point operations *)
let ( *| ) = Vector.( *^ )
let ( |/ ) = Vector.( ^/ )

let ( |+| ) = Vector.( ^+^ )
let ( |*| ) (ux, uy, uz) (vx, vy, vz) = (ux *. vx, uy *. vy, uz *. vz) 

let random () = (Random.float 1., Random.float 1., Random.float 1.)

let has_neg (r, g, b) = Float.(r < 0.) || Float.(g < 0.) || Float.(b < 0.)

(* Defining a color space *)
let white = (1., 1., 1.)
let black = (0., 0., 0.)

let red   = (1., 0., 0.)
let green = (0., 1., 0.)
let blue  = (0., 0., 1.)
