type t = Point.t * Vector.t

val make : Point.t -> Vector.t -> t

val origin: t -> Point.t
val direction : t -> Vector.t

val at : t -> float -> Point.t