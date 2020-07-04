module type S = sig
  type t
  val intersect : t -> Ray.t -> Intersection.t option
end

module Plane : sig
  include S
  val make : point:Point.t -> normal:Vector.t -> t
end

module Sphere : sig
  include S
  val make : center:Point.t -> radius:float -> t
end

type t
val make : (module S with type t = 'a) -> 'a -> t
val intersect : t -> Ray.t -> Intersection.t option