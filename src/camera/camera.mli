module type S = sig
  type t
  val ray_generate : t -> (float * float) -> Ray.t 
end

module Make (VP: View_plane.S) (P: Projection.S) : sig
  include S
  val make : viewer:Viewer.t -> view_plane:VP.t -> projection:P.t -> t
end

