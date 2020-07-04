module type S = sig
  type t

  val project : t -> Viewer.t -> (float * float) -> Ray.t
end

module Orthographic : (S with type t = unit)
module Perspective : (S with type t = float)