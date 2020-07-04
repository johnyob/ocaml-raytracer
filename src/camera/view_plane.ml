open Base

module type S = sig
  type t
  val uv : t -> (float * float) -> (float * float)
end

module Plane = struct  
  type t = { resolution: Image.resolution; l: float; r: float; b: float; t: float }
  let make ~resolution ~l ~r ~b ~t = { resolution; l; r; b; t }

  let uv { resolution=(w, h); l; r; b; t } (x, y) = 
    (l +. (r -. l) *. (x /. Float.of_int w ), t -. (t -. b) *. (y /. Float.of_int h))
    
end