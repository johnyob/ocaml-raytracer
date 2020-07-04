type t = { intersection : Intersection.t; material: Material.t }
let make ~intersection ~material = { intersection; material }

let compare { intersection=x; _ } { intersection=y; _ } = Intersection.compare x y