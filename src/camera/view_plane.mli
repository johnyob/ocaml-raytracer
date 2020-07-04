module type S = sig
  type t
  val uv : t -> (float * float) -> (float * float)
end

module Plane : sig
  type t = { resolution: Image.resolution; l: float; r: float; b: float; t: float }
  val make : resolution:Image.resolution -> l:float -> r:float -> b:float -> t:float -> t
  
  include S with type t := t
end
