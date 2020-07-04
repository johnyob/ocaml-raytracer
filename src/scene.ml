open Base

module type S = sig
  include Object.S
  val objects : t -> Object.t list
end

module ListScene = struct
  type t = { objects: Object.t list }
  let make objects = { objects }

  let hit { objects } ray = 
    objects
    |> List.filter_map ~f:(fun o -> Object.hit o ray)
    |> List.min_elt ~compare:Hit.compare

  let objects { objects } = objects
end