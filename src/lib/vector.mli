type t = float * float * float

exception Divide_by_zero

val zero : t

(* Multiplication by scalar *)
val ( *^ ) :  float -> t -> t

(* Division by a scalar *)
val ( ^/ ) : t -> float -> t

(* Vector addition and subtraction *)
val ( ^+^ ) : t -> t -> t
val ( ^-^ ) : t -> t -> t

val ( ^.^ ) : t -> t -> float
val ( ^*^ ) : t -> t -> t

(* Negate *)
val negate : t -> t

val norm : t -> float

val normalize : t -> t
val normalize_opt : t -> t option

val random : unit -> t

val reflect : i:t -> n:t -> t
val refract : i:t -> n:t -> eta:float -> t option 
