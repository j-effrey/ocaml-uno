open Graphics
open Command
open Camlimages
open Images
open Player
open State

(* Note: this function was taken from the original source code of Camlimages,
   graphic_image.ml. It takes in an image and converts it to a two-d array of colors
 Source:https://bitbucket.org/camlspotter/camlimages/src/1611545463f493462aeafab65839c1112162559a?at=default*)
let array_of_image img =
  match img with
  | Images.Index8 bitmap ->
    let w = bitmap.Index8.width
    and h = bitmap.Index8.height
    and colormap = bitmap.Index8.colormap.map in
    let cmap = Array.map (fun {r = r; g = g; b = b} -> Graphics.rgb r g b) colormap in
    if bitmap.Index8.transparent <> -1 then
      cmap.(bitmap.Index8.transparent) <- transp;
    Array.init h (fun i ->
        Array.init w (fun j -> cmap.(Index8.unsafe_get bitmap j i)))
  | Index16 bitmap ->
    let w = bitmap.Index16.width
    and h = bitmap.Index16.height
    and colormap = bitmap.Index16.colormap.map in
    let cmap = Array.map (fun {r = r; g = g; b = b} -> rgb r g b) colormap in
    if bitmap.Index16.transparent <> -1 then
      cmap.(bitmap.Index16.transparent) <- transp;
    Array.init h (fun i ->
        Array.init w (fun j -> cmap.(Index16.unsafe_get bitmap j i)))
  | Rgb24 bitmap ->
    let w = bitmap.Rgb24.width
    and h = bitmap.Rgb24.height in
    Array.init h (fun i ->
        Array.init w (fun j ->
            let {r = r; g = g; b = b} = Rgb24.unsafe_get bitmap j i in
            rgb r g b))
  | Rgba32 _ | Cmyk32 _ -> failwith "RGBA and CMYK not supported"

(* of_image takes in an Images.t and converts it to an image that can be displayed
 * by graphics *)
let of_image img = Graphics.make_image (array_of_image img)

(* draw_image takes in an Images.t and the lower-left coordinates of where the image
   should be drawn (x, y) and draws the image on the graphical display *)
let draw_image img x y = Graphics.draw_image (of_image img) x y

(* Converts an [Graphics.image] value to an image of value Rgb24.t, which is recognized
 * by this module *)
let image_of grpimg =
  let rgb_of_color color =
    { r = (color lsr 16) land 0xFF;
      g = (color lsr 8) land 0xFF;
      b = color land 0xFF; } in
  let array = Graphics.dump_image grpimg in
  let height = Array.length array in
  let width = Array.length array.(0) in
  let img = Rgb24.create width height in
  for y = 0 to height - 1 do
    for x = 0 to width - 1 do
      Rgb24.unsafe_set img x y (rgb_of_color array.(y).(x))
    done
  done;
  img

(* converts effect of a card to a string *)
let effect_to_str ef = match ef with
  | Plus -> "DrawTwo"
  | Skip -> "Skip"
  | Reverse -> "Reverse"
  | Wild -> "wild"
  | Wild4 -> "drawFour"
  | _ -> "noeffect"

(* converts the color of a card to a string *)
let color_to_str col = match col with
  | Blue -> "blue"
  | Yellow -> "yellow"
  | Green -> "green"
  | Red -> "red"
  | Black -> "black"
  | _ -> failwith("nocolor")

(* takes in a card and outputs the pathway to the .png file of the card
 * in the src folder*)
let card_to_str card = if card.value != -1 then
    "assets/cards/" ^ (color_to_str card.color) ^ (string_of_int card.value) ^ ".png"
  else if card.color = Black then
    "assets/cards/" ^ effect_to_str (card.effect) ^ ".png"
  else "assets/cards/" ^ (color_to_str card.color) ^ (effect_to_str (card.effect)) ^ ".png"

(* maps every card in a list of cards for a user to its .png file pathway *)
let cardlst_to_png s =
  List.map (fun card -> Png.load_as_rgb24 (card_to_str card) []) (user_hand s)

(* draws the human hand, given the list of images for the human's cards, and
   a starting location for the hand in x, y coordinates.
   Prereq: x-coordinate should always start at 535, y start at 75 *)
let rec draw_human_hand img_lst x y = begin match img_lst with
  | [] -> ();
  | h :: t -> if x >= 1100 then let x1 = 535 in let y1 = y-40 in
      draw_image h x1 y1; draw_human_hand t (x1+30) y1;
    else let x1 = x in let y1 = y in
      draw_image h x1 y1; draw_human_hand t (x1+30) y1;
end

(* draws the ai1_hand, given the list of cards in the ai1_hand and the starting
 * lower-left coordinates of the hand.
 * Prereq: coordinates starts at 315, x starts at 1025 *)
let rec draw_ai1_hand ai_hand x y = begin match ai_hand with
  | [] -> ();
  | h :: t -> if y >= 650 then let x1 = x+20 in let y1 = 315 in
      draw_image (Png.load_as_rgb24 "assets/cards/sidewaybackcard.png" []) x1 y1;
      draw_ai1_hand t x1 (y1+20);
    else let x1 = x in let y1 = y in
      draw_image (Png.load_as_rgb24 "assets/cards/sidewaybackcard.png" [])
        x1 y1; draw_ai1_hand t x1 (y1+20);
end

(* draws the ai2_hand, given the list of cards in the ai2_hand and the starting
 * lower-left coordinates of the hand. x start at 535, y start at 589 *)
let rec draw_ai2_hand ai_hand x y = begin match ai_hand with
  | [] -> ();
  | h :: t -> if x >= 900 then let x1 = 535 in let y1 = y+20 in
    draw_image (Png.load_as_rgb24 "assets/cards/upsidebackcard.png" []) x1 y1;
    draw_ai2_hand t (x1+20) y1;
    else let x1 = x in let y1 = y in
    draw_image (Png.load_as_rgb24 "assets/cards/upsidebackcard.png" []) x1 y1;
    draw_ai2_hand t (x1+20) y1;
end

(* draws the ai3_hand, given the list of cards in the ai3_hand and the starting
 * lower-left coordinates of the hand. x starts at 225, y start at 290 *)
let rec draw_ai3_hand ai_hand x y = begin match ai_hand with
  | [] -> ();
  | h :: t -> if y >= 650 then let x1 = x-20 in let y1 = 290 in
    draw_image (Png.load_as_rgb24 "assets/cards/sidewaybackcard2.png" []) x1 y1;
    draw_ai3_hand t x1 (y1+20);
    else let x1 = x in let y1 = y in
    draw_image (Png.load_as_rgb24 "assets/cards/sidewaybackcard2.png" []) x1 y1;
    draw_ai3_hand t x1 (y1+20);
end

(* draws the counter-clockwise arrow on the display *)
let draw_counter () =
  set_line_width 6; draw_arc 640 360 100 100 (-55) 55;
  draw_segments (Array.of_list [697, 277, 695, 300]);
  draw_segments (Array.of_list [697, 277, 720, 277])

(* draws the clockwise arrow on the display *)
let draw_clock () = set_line_width 6;
  draw_arc 550 360 100 100 125 235;
  draw_segments (Array.of_list [495, 279, 490, 305]);
  draw_segments (Array.of_list [495, 279, 471, 277])

  (* converts a card's color variant to the type used by the graphics module *)
let convert_color col = match col with
  | Red -> red
  | Green -> green
  | Blue -> blue
  | Yellow -> yellow
  | Black -> black
  | NoColor -> white

(* takes in a state and draws a circle with the state's current color,
 * indicating the turns move counterclockwise *)
let counter_circle s = set_color (convert_color (current_color s));
  draw_counter (); set_color black; draw_clock()

(* takes in a state and draws a circle with the state's color,
 * indicating the turns move clockwise *)
let clock_circle s = set_color (convert_color (current_color s));
  draw_clock (); set_color black; draw_counter()

(* takes in a state and determines which way to draw the circle *)
let draw_circle s = if is_counter s then counter_circle s else clock_circle s

(* draws the initial state *)
let draw_init_state s = let s1 = update_state (Play init_card) s in
  (* direction arrows *)
  draw_circle s1;
  draw_image (Png.load_as_rgb24 "assets/unobutton.png" []) 435 15;
  draw_human_hand (cardlst_to_png s1) 535 75;
  draw_ai1_hand (ai1_hand s1) 1025 315;
  draw_ai2_hand (ai2_hand s1) 535 589;
  draw_ai3_hand (ai3_hand s1) 225 290;
  draw_image (Png.load_as_rgb24 (card_to_str (top_card s1)) []) 565 300;
