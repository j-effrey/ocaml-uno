 (* An UNO module responsible for the text-based commands and
 * implementation for parsing of the commands. *)
open Player
(* open Ai *)

type command =
  | Play of card
  | Draw
  | Choose of color
  | Uno
  | Info
  | NA
  | Quit

(* User input when entering their command must account for
 * whatever they type in. This normalizes whatever they type
 * in into a readable string *)
let normalize str =
  String.trim (String.lowercase_ascii str)

(* Returns the "command" part of the raw user input, or
 * equivalently, the characters before the first white
 * space ' '. *)
let get_command str =
  let n_str = normalize str in
  if String.contains n_str ' ' then
    let find_space = String.index n_str ' ' in
    String.sub n_str 0 find_space
  else n_str

(* Returns the arguments for a particular command. It may be a
 * string, or may be empty if there is no particular
 * argument for that command. Returns args in a string format. *)
let get_args str =
  let n_str = normalize str in
  let command_len = String.length (get_command n_str) in
  String.trim (String.sub n_str command_len (String.length n_str - command_len))

(* Helper function for parse_args, which shortens our code by determining the
 * effect of the int id of the card ONLY when d is between 50 and 80. *)
let det_effect num =
  if num >= 50 && num < 80 then begin
    match num / 10 with
    | 5 -> Plus
    | 6 -> Skip
    | 7 -> Reverse
    | _ -> NoEffect
  end
  else NoEffect

(* Parses an alternative user input and converts the color they typed in with
 * the int id it's assigned to. *)
let convert_color str =
  match str with
  | "yellow" -> 10
  | "green" -> 20
  | "blue" -> 30
  | "red" -> 40
  | "black" -> 0
  | _ -> -1

(* Parses a string representation of a color and converts it to the color type *)
let str_to_color str =
  match str with
  | "yellow" -> Yellow
  | "green" -> Green
  | "blue" -> Blue
  | "red" -> Red
  | _ -> NoColor

(* If the user types in "play red 4", this is applicable, and our parser is made
 * to handle these cases as well. *)
let convert_to_id arg =
  if String.contains arg ' ' then
    let get_color = get_command arg in let get_num_or_action = get_args arg in
    try
      let num = int_of_string get_num_or_action in
      if num >= 0 && num < 10 then num + (convert_color get_color) else -1
    with
    | _ -> begin
        match get_num_or_action with
        | "draw2" -> 50 + (convert_color get_color)/10
        | "skip" -> 60 + (convert_color get_color)/10
        | "reverse" -> 70 + (convert_color get_color)/10
        | "wild" -> 80
        | "wild4" -> 90
        | _ -> -1
      end
  else -1

(* Converts the int id of the card into the actual card record itself. *)
let rec parse_args arg =
  try
    let id_1 = int_of_string arg in
    begin
      match id_1 with
      | d when d >= 10 && d < 20 -> {value = d mod 10; color = Yellow; effect = NoEffect; id = d}
      | d when d >= 20 && d < 30 -> {value = d mod 10; color = Green; effect = NoEffect; id = d}
      | d when d >= 30 && d < 40 -> {value = d mod 10; color = Blue; effect = NoEffect; id = d}
      | d when d >= 40 && d < 50 -> {value = d mod 10; color = Red; effect = NoEffect; id = d}
      | d when d >= 50 && d < 80 -> begin
        let eff = det_effect d in
        match d mod 10 with
          | 1 -> {value = -1; color = Yellow; effect = eff; id = d}
          | 2 -> {value = -1; color = Green; effect = eff; id = d}
          | 3 -> {value = -1; color = Blue; effect = eff; id = d}
          | 4 -> {value = -1; color = Red; effect = eff; id = d}
          | _ -> {value = -1; color = NoColor; effect = eff; id = -1}
      end
      | d when d = 80 -> {value = -1; color = Black; effect = Wild; id = d}
      | d when d = 90 -> {value = -1; color = Black; effect = Wild4; id = d}
      | _ -> {value = -1; color = NoColor; effect = NoEffect; id = -1}
  end
  with
  | _ -> parse_args (string_of_int (convert_to_id arg))

(* Gets the color given a string representation of that color. *)
let get_color str =
  let col_str = get_args str in
  begin
    match col_str with
    | "red" -> Red
    | "blue" -> Blue
    | "green" -> Green
    | "yellow" -> Yellow
    | _ -> NoColor
  end

(* Parses user-input string into a command and/or its arguments. *)
let parse str =
  match (get_command str) with
  | "play" -> if (parse_args (get_args str)) <> ({value = -1; color = NoColor; effect = NoEffect; id = -1}) then
      Play (parse_args (get_args str)) else
      NA
  | "draw" -> Draw
  | "choose" -> if get_color str = NoColor then NA else Choose (get_color str)
  | "uno" -> if (parse_args (get_args str)) <> ({value = -1; color = NoColor; effect = NoEffect; id = -1}) then
      Uno else
      NA
  | "info" -> Info
  | "quit" -> Quit
  | _ -> NA
