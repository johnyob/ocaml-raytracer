module type S = sig
  type t
  val sample : t -> Image.xy -> Color.t
end

module Stochastic (C: Camera.S) (T: Tracer.S) : sig
  include S
  val make : camera:C.t -> tracer:T.t -> n:int -> t
end

