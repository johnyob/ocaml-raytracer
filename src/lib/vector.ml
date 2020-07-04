open Base

type t = float * float * float

exception Divide_by_zero

let zero = (0., 0., 0.)

let ( *^ ) a (x, y, z) = (a *. x, a *. y, a *. z)

let ( ^/ ) (x, y, z) a = 
  if Float.(a <> 0.) then (x /. a, y /. a, z /. a)
  else raise Divide_by_zero

let negate (x, y, z) = (-. x, -. y, -. z)

let ( ^+^ ) (ux, uy, uz) (vx, vy, vz) = (ux +. vx, uy +. vy, uz +. vz)

let ( ^-^ ) u v = u ^+^ (negate v)

(* cross product *)
let ( ^*^ ) (ux, uy, uz) (vx, vy, vz) = (uy *. vz -. uz *. vy, uz *. vx -. ux *. vz, ux *. vy -. uy *. vx)

let ( ^.^ ) (ux, uy, uz) (vx, vy, vz) = (ux *. vx) +. (uy *. vy) +. (uz *. vz) 

let norm v = (v ^.^ v) |> Float.sqrt

let normalize v = v ^/ (norm v)

let normalize_opt v = 
  try Some (normalize v)
  with Divide_by_zero -> None

let random () = 
  let open Float in
  let theta = pi *. Random.float 1.  
  and phi = 2. *. pi *. Random.float 1. in 
    ((sin theta) *. (cos phi), (sin theta) *. (sin phi), cos theta)

let reflect ~i ~n = i ^-^ (2. *. (i ^.^ n)) *^ n 

let refract ~i ~n ~eta =
  let open Float in 
  let cos_ti = (negate i) ^.^ n in
  let t_ll = eta *^ (i ^+^ cos_ti *^ n) in
  let d = 1. -. (t_ll ^.^ t_ll) in
    if d > 0. then Some (t_ll ^-^ (sqrt d) *^ n)
    else None