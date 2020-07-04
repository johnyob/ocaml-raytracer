open Viewer

module type S = sig
  type t
  val project : t -> Viewer.t -> (float * float) -> Ray.t
end

module Orthographic : (S with type t = unit) = struct
  type t = unit

  let project _ { eye; n; u; v } (u', v') = 
    let open Vector in 
    Ray.make (eye ^+^ u' *^ u ^+^ v' *^ v) (negate n)
    
end

module Perspective : (S with type t = float) = struct
  type t = float

  let project focal_distance { eye; n; u; v } (u', v') = 
    let open Vector in
    Ray.make (eye) (focal_distance *^ (negate n) ^+^ u' *^ u ^+^ v' *^ v)

end

