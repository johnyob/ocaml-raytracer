type resolution = (int * int)
type xy = (int * int)

type t

val make : resolution -> (xy -> Color.t) -> t
val write_to_file : t -> string -> unit
