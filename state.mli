open Queue
open List
open Stack
(* open Player
open Command *)


type direction

(* [state] is an abstract type representing the state of the game. *)
type state = {
  (* size of list 3, where index is the value corresponding to the players
     eg. 0 is the user *)
  players : Player.player list;
  draw_pile : Player.card Queue.t;
  played_pile : Player.card Stack.t;
  current_color: Player.color;
  current_player: Player.player;
  direction: direction;
  turn: int
}


(* [user_hand] is an object of type card list that represents
 * the human player's hand *)
val user_hand : state -> Player.card list

(* [ai1_hand] is an object of type card list that represents
 * AI_1's hand*)
val ai1_hand : state -> Player.card list

(* [ai2_hand] is an object of type card list that represents
 * AI_2's hand*)
val ai2_hand : state -> Player.card list

(* [ai3_hand] is an object of type card list that represents
 * AI_3's hand*)
val ai3_hand : state -> Player.card list

(* [init_state] is an object of type state that represents
 * the starting state of a game of UNO *)
val init_state : state

val init_card : Player.card

(* [turn] returns an int corresponding with which player's turn
 * it is in the current state. 0 will be human's turn  *)
val turn : state -> int

val current_color : state -> Player.color


(* [next_turn] returns an int corresponding with which player's turn
 * it is for the next turn. 0 will represent the human's turn  *)
val next_turn : state -> int

val next_next_turn : state -> int

val is_counter : state -> bool

val current_player : state -> Player.player

val init_pile : unit -> unit

val played_pile : state -> Player.card Stack.t

val players : state -> Player.player list

(* [draw_ouke] returns the current draw_pile  *)
val draw_pile : state -> Player.card Queue.t

(* [top_card] returns an object of type card that represents
 * the card played in the previous turn on top of the stack *)
val top_card : state -> Player.card

(* [check_playability] returns true if a card is playable
 * given the current color and the top card *)
val check_playability: Player.color -> Player.card -> Player.card -> bool

(* [update_state] returns an object of type state that represents
 * the new state of the game after player (user) chooses a card
 * from hand (card list) *)
val update_state : Command.command -> state -> state

(* [get_winner] returns an int corresponding to a player if
 * there is a winner in the current state, returns -1 otherwise *)
val get_winner : state -> int
