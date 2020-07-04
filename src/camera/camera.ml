module type S = sig
  type t
  val ray_generate : t -> (float * float) -> Ray.t 
end

module Make (VP: View_plane.S) (P: Projection.S) = struct
  type t = { viewer: Viewer.t; view_plane: VP.t; projection: P.t }
  let make ~viewer ~view_plane ~projection = { viewer; view_plane; projection }

  let ray_generate { viewer; view_plane; projection } xy = (VP.uv view_plane xy) |> P.project projection viewer  
end     


