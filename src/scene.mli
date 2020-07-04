module type S = sig
  include Object.S
  val objects : t -> Object.t list
end

module ListScene : sig
  include S
  val make : Object.t list -> t
end