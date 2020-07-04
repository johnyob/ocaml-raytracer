type face = Inner | Outer
type t = { ray: Ray.t; t: float; point: Point.t; normal: Vector.t; face: face }

val make : ray:Ray.t -> t:float -> normal:Vector.t -> t

val compare : t -> t -> int