open Player
open State
open Command
open Random

(* [effect] represents a possible effect of the card. *)
type effect = Skip | Plus | Reverse | NoEffect | Wild | Wild4

(* [color] represents the color of a card *)
type color = Red | Green | Blue | Yellow | Black | NoColor

(* Helper function for dumb AI that determines if a Wild card or
 * Wild4 card exists in the hand to play. *)
let rec does_wild4_exist hand =
  match hand with
  | [] -> None
  | h::t -> if h.effect = Wild4 || h.effect = Wild then Some h else does_wild4_exist t

(* Helper for dumb AI that determines the first playable card in its hand.
 * Returns a card option. *)
let rec find_possible_card color num eff hand =
  match hand with
  | [] -> None
  | h::t -> begin
      if h.color = color then Some h else
      if h.effect = NoEffect && h.value = num then Some h else
      if h.effect = eff && h.effect <> NoEffect then Some h else
        find_possible_card color num eff t
    end

(* One potential algorithm for the AI to play cards. The way it works
 * is a rudimentary "find first card" method. It plays the first card it sees.
 * In our implementation, we decided to only use the Smart AI however. *)
let dumbai_choose_card s =
  let top_card = top_card s in let hand = (current_player s).hand in
  let exists_card = find_possible_card (top_card.color) (top_card.value) (top_card.effect) hand in
  match exists_card with
  | None -> begin
      match (does_wild4_exist hand) with
      | None -> Draw (* {value = -1; color = NoColor; effect = NoEffect; id = -1} *)
      | Some x -> Draw (* {value = -1; color = Red; effect = x.effect; id = x.id} *)
    end
  | Some h -> Play h


(* returns a list of all the possible cards you could play
 * given a top_card. Includes cards of the same color, value, effect, or
 * Wild cards. (implemented in a way that reverses original order)*)
let rec get_possible_list hand top_card lst s =
  match hand with
  | [] -> lst
  | h::t ->
    if h.color = Black then get_possible_list t top_card (h::lst) s else
    if h.color = (current_color s) then get_possible_list t top_card (h::lst) s else
    if (h.effect = NoEffect && top_card.effect = NoEffect && h.value = top_card.value)
    then get_possible_list t top_card (h::lst) s else
    if (h.effect = top_card.effect && h.effect <> NoEffect && top_card.effect <> NoEffect)
    then get_possible_list t top_card (h::lst) s else
      get_possible_list t top_card lst s

(* counts the number of colors you have in your hand and stores each value in
 * a tuple in the order Y,G,B,R,Bl. *)
let rec color_count hand tup =
  match hand with
  | [] -> tup
  | h::t -> begin
      match tup with
      | (y,g,b,r,bl) -> if h.color = Yellow then color_count t (y+1,g,b,r,bl) else
        if h.color = Green then color_count t (y,g+1,b,r,bl) else
        if h.color = Blue then color_count t (y,g,b+1,r,bl) else
        if h.color = Red then color_count t (y,g,b,r+1,bl) else
          color_count t (y,g,b,r,bl+1)
    end

(* extracting values in a 5 tuple. *)
let fir tup =
  match tup with
  | (t,_,_,_,_) -> t
let sen tup =
  match tup with
  | (_,t,_,_,_) -> t
let trd tup =
  match tup with
  | (_,_,t,_,_) -> t
let frt tup =
  match tup with
  | (_,_,_,f,_) -> f
let fif tup =
  match tup with
  | (_,_,_,_,f) -> f

(* finds out which color you have the most of, and returns an integer representing
 * that particular color. *)
let most_color tup =
  match tup with
  | (y,g,b,r,_) -> if (max (max (max y g) b) r) = y then Yellow else
    if (max (max (max y g) b) r) = g then Green else
    if (max (max (max y g) b) r) = b then Blue else
    if (max (max (max y g) b) r) = r then Red else Black

(* Returns the card with the highest heuristic value. This
 * determines which card the Smart AI should play given the current situation.
 * This is a helper function for our Smart AI choose card method. *)
let rec find_max lst num c =
  match lst with
  | [] -> c
  | (n,ca)::t -> if n > num then find_max t n ca else find_max t num c

(* Method that determines what the best color to call is for an AI. Its
 * implementation looks at how many of each color is in the hand, and chooses the
 * highest color. *)
let call_color lst =
  match most_color (color_count lst (0,0,0,0,0)) with
  | Red -> Player.Red
  | Yellow -> Player.Yellow
  | Green -> Player.Green
  | _ -> Player.Blue

(* let random_col =
  Random.self_init();
  match (Random.int 4) with
  | 0 -> Player.Red
  | 1 -> Player.Yellow
  | 2 -> Player.Green
   | _ -> Player.Blue *)

(* Returns a command to play the best card in the smart AI function. *)
let helper_best lst tf hand =
  if tf = true then Choose (call_color hand) else
  if List.length lst = 0 then Draw else
    let best_card = find_max lst 0 ({value = -1; color = NoColor; effect = NoEffect; id = -1}) in
    if (best_card = {value = -1; color = NoColor; effect = NoEffect; id = -1}) then Draw else
    Play best_card

(* Assigns heuristic numerical values to each card. There is a different number
 * for different situations, and the higher the number, the more likely it should be
 * played. *)
let rec find_best_card hand (c : Player.color) top_card num_h s lst =
  if c = NoColor then helper_best lst true (current_player s).hand else begin
    match hand with
    | [] -> helper_best lst false (current_player s).hand
    | h::t ->
      if (next_turn s = 0) then
        if (h.effect = Skip || h.effect = Plus || h.effect = Reverse)
        then find_best_card t c top_card num_h s ((50,h)::lst)
        else if (h.effect = Wild4) then if (num_h <= 3)
          then find_best_card t c top_card num_h s ((100,h)::lst)
          else find_best_card t c top_card num_h s ((45,h)::lst)
        else if (h.effect = Wild) then if (List.length hand <= 3)
          then find_best_card t c top_card num_h s ((75,h)::lst)
          else find_best_card t c top_card num_h s ((20,h)::lst)
        (* else NoEffect *)
        else if (h.value = 0) then if (h.color = c)
          then find_best_card t c top_card num_h s ((40,h)::lst)
          else find_best_card t c top_card num_h s ((30,h)::lst)
        else if (h.color = c) then find_best_card t c top_card num_h s ((25,h)::lst)
        else find_best_card t c top_card num_h s ((20,h)::lst)
      else if (next_next_turn s = 0) then
        if (h.effect = Skip || h.effect = Plus || h.effect = Wild4)
        then find_best_card t c top_card num_h s ((10,h)::lst)
        else if (h.effect = Reverse) then find_best_card t c top_card num_h s ((20,h)::lst)
        else if (h.effect = Wild) then if (List.length hand <= 3)
          then find_best_card t c top_card num_h s ((50,h)::lst)
          else find_best_card t c top_card num_h s ((20,h)::lst)
        (* else NoEffect *)
        else if (h.value = 0) then if (h.color = c)
          then find_best_card t c top_card num_h s ((60,h)::lst)
          else find_best_card t c top_card num_h s ((55,h)::lst)
        else find_best_card t c top_card num_h s ((52,h)::lst)
      else
      if (h.effect = Reverse || h.effect = Wild4)
      then find_best_card t c top_card num_h s ((5,h)::lst)
      else if (h.effect = Skip || h.effect = Plus)
      then find_best_card t c top_card num_h s ((15,h)::lst)
      else if (h.effect = Wild)
      then find_best_card t c top_card num_h s ((25,h)::lst)
      else if (h.value = 0) then if (h.color = c)
        then find_best_card t c top_card num_h s ((70,h)::lst)
        else find_best_card t c top_card num_h s ((60,h)::lst)
        else find_best_card t c top_card num_h s ((50,h)::lst)
  end

(* Method used to determine which card the AI plays. Ultimately returns a command. *)
let smartai_choose_card s =
  let curr = current_player s in let hand = curr.hand in
  let get_human = List.find (fun x -> x.id = 0) (players s) in
  let num_h_cards = List.length (get_human.hand) in
  let possible_plays = get_possible_list hand (top_card s) [] s in
  if current_color s = Black
  then find_best_card possible_plays NoColor (top_card s) num_h_cards s [] else
  let curr_hand_stats = color_count possible_plays (0,0,0,0,0) in
  begin
    match most_color (curr_hand_stats) with
    | Yellow -> find_best_card possible_plays Yellow (top_card s) num_h_cards s []
    | Green -> find_best_card possible_plays Green (top_card s) num_h_cards s []
    | Blue -> find_best_card possible_plays Blue (top_card s) num_h_cards s []
    | Red -> find_best_card possible_plays Red (top_card s) num_h_cards s []
    | _ -> find_best_card possible_plays Black (top_card s) num_h_cards s []
  end
