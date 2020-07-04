type face = Inner | Outer
type t = { ray: Ray.t; t: float; point: Point.t; normal: Vector.t; face: face }

let make ~ray:((_, b) as ray) ~t ~normal = 
  let open Vector in
  let (normal, face) = if b ^.^ normal > 0. then (negate normal, Inner) else (normal, Outer) in
    { ray; t; point=Ray.at ray t; normal=Vector.normalize normal; face }
  
    

let compare { t=t1; _ } { t=t2; _ } = Pervasives.compare t1 t2