module type S = sig
  type t
  val trace : t -> Ray.t -> Color.t
end


module PathTracer (S: Scene.S) = struct
  type t = { background: (Ray.t -> Color.t); depth: int; scene: S.t }
  let make ~background ~depth ~scene = { background; depth; scene }

  let trace { background; depth; scene } ray = 
    let rec trace_inner ray n = match n with
      | 0 -> Color.black
      | n ->
        match S.hit scene ray with
          | None -> background ray
          | Some Hit.{ intersection; material } ->
            match Material.scatter material intersection with
              | None -> Color.black
              | Some (attenutation, ray) -> Color.(attenutation |*| (trace_inner ray (n - 1)))
    in trace_inner ray depth
end