module type S = sig
  type t
  val trace : t -> Ray.t -> Color.t
end

module PathTracer (S: Scene.S) : sig
  include S
  val make : background:(Ray.t -> Color.t) -> depth:int -> scene:S.t -> t
end
