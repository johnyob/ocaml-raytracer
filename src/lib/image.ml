open Base
open Stdio

type xy = (int * int)
type pixel = (int * int * int)

type resolution = (int * int)
type t = { resolution: resolution; img: pixel array array }

let to_pixel (r, g, b) = 
  let f c = Int.of_float (255.999 *. (Float.clamp_exn c ~min:0. ~max:1.)) 
  in (f r, f g, f b)

let make ((w, h) as resolution) f = 
  let np = w * h in
    { resolution; img=(Array.init h ~f:(fun y -> Array.init w ~f:(fun x -> to_pixel (f (x, y))))) }

let write_to_file { resolution=(w, h); img } filename = 
  let channel = Out_channel.create (filename ^ ".ppm") in
  Out_channel.fprintf channel "P3\n%d %d\n255\n" w h;
  Array.iter ~f:(fun row ->
    Array.iter ~f:(fun (r, g, b) -> Out_channel.fprintf channel "%4d%4d%4d" r g b) row; Out_channel.fprintf channel "\n"
  ) img
