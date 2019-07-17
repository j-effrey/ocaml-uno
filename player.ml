type effect = Skip | Plus | Reverse | NoEffect | Wild | Wild4

(* [color] represents the color of a card *)
type color = Red | Green | Blue | Yellow | Black | NoColor

type intelligence = AI | Human

(* [card] represents a card in the UNO game*)
type card = {value: int; color: color; effect: effect; id: int}

type player = {id: int; name: string; mutable hand: card list; intelligence: intelligence;}

let cards_left lst = List.length lst
