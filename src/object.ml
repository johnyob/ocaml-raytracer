module type S = sig
  type t
  val hit : t -> Ray.t -> Hit.t option
end

type t = (Surface.t * Material.t)

let hit (surface, material) ray = match Surface.intersect surface ray with
  | None -> None
  | Some intersection -> Some (Hit.make intersection material)