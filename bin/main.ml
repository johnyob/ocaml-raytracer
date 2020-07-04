open Raytracer
open Base

(* Camera initialization *)
module Camera = Camera.Make(View_plane.Plane)(Projection.Perspective)

let degrees_to_radians x = x *. (Float.pi /. 180.)

let resolution = (1600, 900)
let viewer = Viewer.make ~eye:(13., 2., 3.) ~at:(0., 0., 0.) ~up:(0., 1., 0.)

let aspect = 16. /. 9.
let t = Float.tan (degrees_to_radians 10.)
let r = aspect *. t
let projection = 1.

let plane = View_plane.Plane.make ~resolution:resolution ~l:(-.r) ~r:r ~b:(-.t) ~t:t
let cam = Camera.make viewer plane projection 

(* Scene Initialization *)

module S = Surface
module M = Material

let random_spheres =
  let make_sphere c = S.make (module S.Sphere) (S.Sphere.make c 0.2) in
  let big_spheres = [(0, 0), 1; (-4, 0), 1; (4, 0), 1] in
  let near (x', y') (x, y) r = Int.abs(x' - x) <= r && Int.abs(y' - y) <= r in
  let spheres = 484 in
    List.range 1 spheres
    |> List.map ~f:(fun x -> (x / 22 - 11, Int.rem x 22 - 11))
    |> List.filter ~f:(fun p -> big_spheres |> List.exists ~f:(fun (p', r) -> near p p' r) |> not) 
    |> List.map ~f:(fun (x, y) -> let f c = Float.of_int c +. 0.9 *. Random.float 1. in (f x, 0.2, f y))
    |> List.map ~f:(fun c ->
      let sphere = make_sphere c 
      and p = Random.float 1. in
        if Float.(p < 0.8) then 
          let lambertian = M.make (module M.Lambertian) (M.Lambertian.make (Color.random ())) in
            (sphere, lambertian)
        else if Float.(p < 0.95) then
          let metal = M.make (module M.Metal) (M.Metal.make (Color.random ()) (Random.float 1.)) in
            (sphere, metal)
        else 
          let dielectric = M.make (module M.Dielectric) (M.Dielectric.make 1.5) in
            (sphere, dielectric) 
    )

let ground = (S.make (module S.Sphere) (S.Sphere.make (0., -1000., 0.) 1000.), M.make (module M.Lambertian) (M.Lambertian.make (0.5, 0.5, 0.5)))

let sphere1 = (S.make (module S.Sphere) (S.Sphere.make (4., 1., 0.) 1.), M.make (module M.Metal) (M.Metal.make (0.7, 0.6, 0.5) 0.0))
let sphere2 = (S.make (module S.Sphere) (S.Sphere.make (0., 1., 0.) 1.), M.make (module M.Dielectric) (M.Dielectric.make 1.5))
let sphere3 = (S.make (module S.Sphere) (S.Sphere.make (-.4., 1., 0.) 1.), M.make (module M.Lambertian) (M.Lambertian.make (0., 0., 1.)))


let scene = Scene.ListScene.make ([ sphere1; sphere2; sphere3; ground ] @ random_spheres)


(* Tracer Initialization *)

let background ray = 
  let open Color in
  let (_, y, _) = Ray.direction ray in
  let t = 0.5 *. (y +. 1.) in
  ((1. -. t) *| white) |+| (t *| (0.5, 0.7, 1.))

module ListSceneTracer = Tracer.PathTracer(Scene.ListScene)
let tracer = ListSceneTracer.make background 50 scene 

(* Sampler Initialization *)

module Sampler = Sampler.Stochastic(Camera)(ListSceneTracer)
let sampler = Sampler.make cam tracer 100

(* main *)

let tonemap (r, g, b) ~gamma = 
  let open Float in
  let f c = c ** (1. /. gamma) in
    (f r, f g, f b) 

let () = 
  let filename = "image" in
  let img = Image.make resolution (fun xy -> Sampler.sample sample xy |> tonemap ~gamma:2.2) 
  in Image.write_to_file img filename
  