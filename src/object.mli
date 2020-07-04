module type S = sig
  type t
  val hit : t -> Ray.t -> Hit.t option
end

type t = (Surface.t * Material.t)
val hit : t -> Ray.t -> Hit.t option