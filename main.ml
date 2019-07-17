open State
open Command
open Player
open Graphics
open Gui
open Ai

(* clears the user's hand on the display and redraws the updated hand *)
let update_user_hand updated_s = fill_rect 535 0 745 183;
  (draw_human_hand (cardlst_to_png updated_s) 535 75)

(* clears ai1's hand on the display and redraws the updated hand *)
let update_ai1_hand updated_s = fill_rect 1025 315 720 405;
  draw_ai1_hand (ai1_hand updated_s) 1025 315

(* clears ai2's hand on the display and redraws the updated hand *)
let update_ai2_hand updated_s = fill_rect 525 589 335 108;
  draw_ai2_hand (ai2_hand updated_s) 535 589

(* clears ai3's hand on the display and redraws the updated hand *)
let update_ai3_hand updated_s = fill_rect 225 290 108 430;
  draw_ai3_hand (ai3_hand updated_s) 225 290

(* updates all hands *)
let update_hand old_s updated_s =
  set_color 0xb30000;
   if user_hand old_s <> user_hand updated_s then
     update_user_hand updated_s;
   if ai1_hand updated_s <> ai1_hand old_s then
     update_ai1_hand updated_s;
  if ai2_hand updated_s <> ai2_hand old_s then
  update_ai2_hand updated_s;
  if ai3_hand updated_s <> ai3_hand old_s then
    update_ai3_hand updated_s


(* redraws the updated arrow given the updated turn and color in the new state*)
let update_arrow updated_s = draw_circle (updated_s)

(* redraws the text of each player, given who's turn it is. the current player
   will have their text highlighted in green *)
let update_turn updated_s = set_color green;
  let p = current_player updated_s in match p.id with
  | 0 -> moveto 450 185; draw_string "Player 1";
         set_color black;
    moveto 1050 185; draw_string "Player 2";
    moveto 450 700; draw_string "Player 3";
    moveto 250 160; draw_string "Frank";
  | 1 -> moveto 1050 185; draw_string "Player 2";
    set_color black;
    moveto 450 185; draw_string "Player 1";
    moveto 450 700; draw_string "Player 3";
    moveto 250 160; draw_string "Frank";
  | 2 -> moveto 450 700; draw_string "Player 3";
    set_color black;
    moveto 450 185; draw_string "Player 1";
    moveto 1050 185; draw_string "Player 2";
    moveto 250 160; draw_string "Frank";
  | 3 -> moveto 250 160; draw_string "Frank";
    set_color black;
    moveto 450 185; draw_string "Player 1";
    moveto 1050 185; draw_string "Player 2";
    moveto 450 700; draw_string "Player 3";
  | _ -> failwith("player does not exist")

(* updates the played pile with the image of the most recently played card *)
let update_stack updated_s =
  draw_image (Png.load_as_rgb24 (card_to_str (top_card updated_s)) []) 565 300

(* takes in a command, the old state, and the new state, and uses the above
   helper methods to update the gui accordingly *)
let update_gui cmd old_s updated_s = match cmd with
| Play c ->
  update_hand old_s updated_s;
  update_arrow updated_s;
  update_stack updated_s;
  update_turn updated_s
| Draw -> update_hand old_s updated_s; update_arrow updated_s;
  update_turn updated_s;
| Uno -> update_hand old_s updated_s;
  update_turn updated_s;
  update_stack updated_s;
| Choose c -> update_arrow updated_s;
  update_turn updated_s;
| _ -> ()

(* returns a list of (coordinates, card) for each card in a user's hand *)
let rec one_row hand x y acc = begin match hand with
| [] -> List.rev acc
| h :: [] -> List.rev ((((x, y), ((x+69), (y+108))), h) :: acc)
| h :: t -> one_row t (x+30) y ((((x, y), ((x+30), (y+108))), h) :: acc)
end

(* returns a list of (coordinates, card) for each card in a user's hand,
 * the user's hand may have multiple rows of cards *)
let rec mult_row row_lst x y =
begin match row_lst with
| [] -> []
| h :: [] -> one_row h 535 y []
| h :: t -> begin match h with
    | [] -> begin match t with
        | [] -> []
        | h1 :: t1 -> mult_row (h1 :: t1) 535 (y-40)
      end
    | h1 :: t1 -> (((x, y+40), ((x+30), (y+68))), h1) :: (mult_row (t1 :: t) (x+30) y)
  end
end

(* gets the first n elements of a list by return a tuple of a list with the
   first n elements, and a list with the rest of the elements *)
let rec get_first_n lst n acc = if n = 0 then ((List.rev acc), lst) else
begin match lst with
  | [] -> (List.rev acc), lst
  | h :: t -> get_first_n t (n-1) (h :: acc)
end

(* splits a list into multiple lists with size 19 or smaller *)
let rec split_lst lst acc n =
if n = 0 then List.rev acc else
  begin match lst with
    | [] -> List.rev acc
    | h :: t -> let (fstn, rest) = (get_first_n (h :: t) 19 []) in
      split_lst rest (fstn :: acc) (n-1)
  end

(* converts a human's hand to a list of tuples mapping the coordinates to
 * the specific card *)
let convert_hand_to_pos human_hand =
  let lst = split_lst human_hand [] (((List.length human_hand)/19) + 1) in
  if List.length lst > 1 then mult_row lst 535 103 else mult_row lst 535 75

(* returns true if the status click is in bounds with one of the coordinates
   within the position list *)
let in_position status position =
let coordinates = fst position in
status.mouse_x >= fst (fst coordinates) && status.mouse_x <= fst (snd coordinates)
   && status.mouse_y >= snd (fst coordinates) && status.mouse_y <= snd (snd coordinates)

(* converts an event status to a possible command  *)
let convert_statustocmd status positions =
try let (_, card) = (List.find (in_position status) positions)
in Play card with
| _ -> if (status.mouse_x >= 850 && status.mouse_x <= 950 && status.mouse_y >= 291
         && status.mouse_y <= 447) then Draw
else if (status.mouse_x >= 425 && status.mouse_x <= 515 && status.mouse_y >= 15
         && status.mouse_y <= 60) then Uno
else if (status.mouse_x >= 500 && status.mouse_x <= 530 && status.mouse_y >= 220
         && status.mouse_y <= 250) then Choose Yellow
else if (status.mouse_x >= 550 && status.mouse_x <= 580 && status.mouse_y >= 220
         && status.mouse_y <= 250) then Choose Green
else if (status.mouse_x >= 600 && status.mouse_x <= 630 && status.mouse_y >= 220
         && status.mouse_y <= 250) then Choose Blue
else if (status.mouse_x >= 650 && status.mouse_x <= 680 && status.mouse_y >= 220
         && status.mouse_y <= 250) then Choose Red
else NA

(* converts a click event into an event status  *)
let parse_click curr_hand =
  let positions = (convert_hand_to_pos curr_hand) in
  let status = wait_next_event [Button_down] in
  convert_statustocmd status positions

let rec check_for_winner players =
  match players with
  | [] -> false
  | p::others -> if List.length p.hand = 0 then true
    else check_for_winner others

let end_screen s =
  moveto 570 435;
  set_color black;
  let winnerid = get_winner s in
  if winnerid = 0 then draw_string ("You win!");
  if winnerid = 0 then draw_image (Png.load_as_rgb24 "assets/player1.png" []) 550 450;
  if winnerid = 1 then draw_image (Png.load_as_rgb24 "assets/player2.png" []) 550 450;
  if winnerid = 1 then draw_string "Player 2 wins!";
  if winnerid = 2 then draw_image (Png.load_as_rgb24 "assets/player3.png" []) 550 450;
  if winnerid = 2 then draw_string "Player 3 wins!";
  if winnerid = 3 then draw_image (Png.load_as_rgb24 "assets/frank.png" []) 550 450;
  if winnerid = 3 then draw_string "Player 4 wins!";
  Unix.sleep (10);
  exit 0

(* this is the repl loop that allows the game to play. If the current state has
   a current player of an ai, then the ai module will choose a command. Otherwise,
   for a human, the repl will parse the position of the user's click and return
   a command.
*)
let rec repl_loop s =
  if check_for_winner s.players then
   end_screen s
  else let curr = current_player s in
  if curr.id != 0 then (Unix.sleep 2);
  let cmd =
    if curr.id = 0 then parse_click curr.hand else Ai.smartai_choose_card s in
  let updated_s = update_state cmd s in
  begin match cmd with
    | Play c ->
      if updated_s != s then update_gui (Play c) s updated_s;
      repl_loop updated_s;
      if updated_s = s then print_endline("Play a valid card");
      repl_loop s;
    | Draw -> update_gui (Draw) s updated_s;
      repl_loop updated_s;
    | Choose col -> update_gui (Choose col) s updated_s;
      repl_loop updated_s;
    | Info -> print_endline("info goes here"); repl_loop s;
    | Uno -> update_gui (Uno) s updated_s;
      repl_loop updated_s;
      if updated_s = s then print_endline("Play a valid card");
      repl_loop s;
    | Quit -> exit 0;
    | _ -> print_endline("\n**Console**: not a valid command");
      repl_loop s;
  end

(* the main game, where everything, including the assets, colors, windows,
   and initial state are set up
*)
let main () = open_graph " 1280x720";
  set_window_title "Uno";
  set_color 0xb30000;
  fill_rect 0 0 1280 720;

  (*drawing the draw pile *)
  draw_image (Png.load_as_rgb24 "assets/draw.png" []) 850 300;
  draw_image (Png.load_as_rgb24 "assets/draw.png" []) 847 297;
  draw_image (Png.load_as_rgb24 "assets/draw.png" []) 844 294;
  draw_image (Png.load_as_rgb24 "assets/draw.png" []) 841 291;

  set_color black;
  moveto 450 185;
  draw_string "Player 1";
  draw_image (Png.load_as_rgb24 "assets/player1.png" []) 425 75;

  moveto 1050 185;
  draw_string "Player 2";
  draw_image (Png.load_as_rgb24 "assets/player2.png" []) 1025 205;

  moveto 450 700;
  draw_string "Player 3";
  draw_image (Png.load_as_rgb24 "assets/player3.png" []) 425 590;

  moveto 250 160;
  draw_string "Frank";
  draw_image (Png.load_as_rgb24 "assets/frank.png" []) 225 175;

  moveto 420 230;
  draw_string "Choose color";
  set_color yellow;
  fill_rect 500 220 30 30;
  set_color green;
  fill_rect 550 220 30 30;
  set_color blue;
  fill_rect 600 220 30 30;
  set_color red;
  fill_rect 650 220 30 30;

  Random.self_init();
  init_pile ();
  draw_init_state init_state;
  update_turn init_state;

  repl_loop init_state

  let () = main ()
