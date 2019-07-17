open Player
(* open Ai *)
(* [command] represents a command input by a player. *)
type command =
  | Play of card             (* Plays a card in your hand with the int "id" you specify.
                             * "id" calculated from the string as follows:
                               * Y:       10 + face/action value
                               * G:       20 + face/action value
                               * B:       30 + face/action value
                               * R:       40 + face/action value
                               * +2:      50 + color value/10
                               * Skip:    60 + color value/10
                               * Reverse: 70 + color value/10
                               * W:       80, 81, 82, 83
                               * W4:      90, 91, 92, 93*)
  | Draw                    (* Draws a card from the draw pile and place it in your hand *)
  | Choose of color         (* Changes the color of the play pile *)
  | Uno                     (* Declares "UNO" and plays a card in your hand with
                              * the int "id" you specify. *)
  | Info 										(* prints information about the state of the game *)
  | NA                      (* For invalid commands *)
  | Quit                    (* Quit the game *)

(* [parse str] is the command that represents player input [str].
 * The command is of type int because the int signifies which
 * card the user would like to place.
 * requires: [str] is a card in the player's hand. *)
val parse : string -> command

val get_args : string -> string

val get_command : string -> string

val det_effect : int -> effect
