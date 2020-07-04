type t = float * float * float

(* Color point operations *)
val ( *| ) :  float -> t -> t
val ( |/ ) : t -> float -> t

val ( |+| ) : t -> t -> t
val ( |*| ) : t -> t -> t

val random : unit -> t
val has_neg : t -> bool

(* Defining a color space *)
val white : t
val black : t

val red   : t
val green : t
val blue  : t