type t = { intersection : Intersection.t; material: Material.t }
val make : intersection:Intersection.t -> material:Material.t -> t

val compare : t -> t -> int