open Intersection
open Base

module type S = sig
  type t
  val scatter : t -> Intersection.t -> (Color.t * Ray.t) option
end

let epsilon = 0.

module Lambertian = struct
  type t = { color: Color.t }
  let make ~color = { color }

  let random_direction () = 
    let open Float in
    let a = 2. *. pi *. Random.float 1. in 
    let z = Random.float 2. -. 1. in
    let r = sqrt (1. -. z *. z) in
      (r *. cos a, r *. sin a, z)

  let scatter { color } { point; normal; _ }  = 
    let open Vector in
    let direction = (normal ^+^ random_direction ()) in
    let scattered = Ray.make (point) direction in
      Some (color, scattered)

end

module Metal = struct
  type t = { color: Color.t; fuzz: float }
  let make ~color ~fuzz = { color; fuzz }

  let scatter { color; fuzz } { ray=(_, direction); point; normal; _ } =
    let open Vector in
    let direction = (reflect direction normal) ^+^ (fuzz *^ random ()) in 
    let scattered = Ray.make (point ^+^ (epsilon *^ direction)) direction in
      if Float.(direction ^.^ normal <= 0.) then None
      else Some (color, scattered) 

end

module Dielectric = struct
  type t = { refractive_index : float } 
  let make ~refractive_index = { refractive_index } 

  let attenutation = (1., 1., 1.)

  let schlick cos_ti eta = 
    let open Float in
    let r0 = ((1. -. eta) /. (1. +. eta)) ** 2. in 
      r0 +. (1. -. r0) *. ((1. -. cos_ti) ** 5.)

  let scatter { refractive_index } { ray=(_, b); point; normal=n; face; _ } = 
    let open Float in
    let eta = match face with
      | Outer -> 1. / refractive_index 
      | Inner -> refractive_index
    in 
    match Vector.refract ~i:b ~n:n ~eta:eta with
      | None -> Some (attenutation, Ray.make point (Vector.reflect ~i:b ~n:n))
      | Some refracted ->
        if Random.float 1. < schlick Vector.((negate b) ^.^ n) eta then
          Some (attenutation, Ray.make point (Vector.reflect ~i:b ~n:n))
        else
          Some (attenutation, Ray.make point refracted)

end



module type I = sig
  module M : S
  val material : M.t
end

type t = (module I) 
let make (type a)
  (module M : S with type t = a) material
  = (module struct
      module M = M
      let material = material
    end : I)

let scatter (module M : I) = M.M.scatter M.material
