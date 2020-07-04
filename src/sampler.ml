open Base

module type S = sig
  type t
  val sample : t -> Image.xy -> Color.t
end

module Stochastic (C: Camera.S) (T: Tracer.S) = struct
  type t = { camera: C.t; tracer: T.t; n: int}
  let make ~camera ~tracer ~n = { camera; tracer; n }

  let sample { camera; tracer; n } (x, y) = 
    let open Color in 
    let f c = Float.of_int c +. Random.float 1. in
      (List.range 1 n
      |> List.map ~f:(fun _ -> C.ray_generate camera (f x, f y) |> T.trace tracer)
      |> List.fold_left ~init:black ~f:( |+| ))
      |/ (Float.of_int n)
end

(* TODO: Add more samplers *)