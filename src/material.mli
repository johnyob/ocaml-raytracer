module type S = sig
  type t
  val scatter : t -> Intersection.t -> (Color.t * Ray.t) option
end

module Lambertian : sig
  include S
  val make : color:Color.t -> t
end

module Metal : sig
  include S
  val make : color:Color.t -> fuzz:float -> t
end

module Dielectric : sig
  include S
  val make : refractive_index:float -> t
end

type t
val make : (module S with type t = 'a) -> 'a -> t

val scatter : t -> Intersection.t -> (Color.t * Ray.t) option
