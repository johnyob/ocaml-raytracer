module type S = sig
  type t

  val intersect : t -> Ray.t -> Intersection.t option
end

let epsilon = 0.00000001

module Plane = struct
  type t = { point: Point.t; normal: Vector.t }
  
  let make ~point ~normal = { point; normal = Vector.normalize normal }

  let intersect { point; normal=n } ((a, b) as ray) =
    let open Vector in 
    let p = point ^.^ n and bn = b ^.^ n in
    let t = (p -. (a ^.^ n)) /. bn in
      if bn > epsilon || t < epsilon then None 
      else Some (Intersection.make ray t n)

end

module Sphere = struct
  type t = { center: Point.t; radius: float }
  let make ~center ~radius = { center; radius }

  let solve_quadratic ~a ~b ~c = 
    let delta = (b *. b -. 4. *. a *. c) in
      if delta <= 0. then None
      else 
        let d = sqrt delta in
        Some ((-.b -. d) /. (2. *. a), (-.b +. d) /. (2. *. a))

  let intersect { center=c; radius=r } ((a, b) as ray) = 
    let open Vector in
    let ac = a ^-^ c in
    match solve_quadratic ~a:(b ^.^ b) ~b:(2. *. (b ^.^ ac)) ~c:((ac ^.^ ac) -. (r *. r)) with
      | Some (t1, _) when t1 > epsilon -> Some (Intersection.make ray t1 ((Ray.at ray t1 ^-^ c) ^/ r))  
      | Some (_, t2) when t2 > epsilon -> Some (Intersection.make ray t2 ((Ray.at ray t2 ^-^ c) ^/ r)) 
      | _ -> None

end


module type I = sig
  module S : S
  val surface : S.t
end

type t = (module I)
let make (type a)
  (module S : S with type t = a) surface 
  = (module struct 
      module S = S
      let surface = surface
    end : I)

let intersect (module S : I) = S.S.intersect S.surface