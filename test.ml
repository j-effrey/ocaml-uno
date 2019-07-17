open OUnit2
open Player
open Command
open State
open Ai
open List

  let card1 = {value = 4; color = Red; effect = NoEffect; id = 44}
  let card2 = {value = 5; color = Blue; effect = NoEffect; id = 35}
  let card5 = {value = 6; color = Red; effect = NoEffect; id = 46}
  let card3 = {value = 8; color = Yellow; effect = NoEffect; id = 18}
  let card4 = {value = 2; color = Green; effect = NoEffect; id = 22}
  let card6 = {value = 5; color = Blue; effect = NoEffect; id = 35}

  let card7 = {value = -1; color = Blue; effect = Skip; id = 63}
  let card8 = {value = -1; color = Yellow; effect = Plus; id = 51}
  let card9 = {value = -1; color = Green; effect = Reverse; id = 72}
  let card10 = {value = -1; color = Yellow; effect = Skip; id = 61}
  let card11 = {value = -1; color = Black; effect = Wild; id = 80}
  let card12 = {value = -1; color = Black; effect = Wild4; id = 90}

  let ncard = {value = -1; color = NoColor; effect = NoEffect; id = -1}

  let hand1 = card1::card2::card5::card3::card4::card6::[]
  let hand2 = card2::card5::card3::card4::card6::[]
  let hand3 = card3::[]

  let hand4 = hand1 @ (card7::card8::card9::card10::card11::card12::[])

  let top_card0 = {value = 5; color = Red; effect = NoEffect; id = 43}
  let top_card1 = {value = 7; color = Green; effect = NoEffect; id = 27}
  let top_card2 = {value = 0; color = Red; effect = NoEffect; id = 40}
  let top_card3 = {value = 9; color = Blue; effect = NoEffect; id = 39}
  let top_card4 = {value = -1; color = Blue; effect = Plus; id = 53}

  (*red*)
  let red0 = {value = 0; color = Red; effect = NoEffect; id = 40}
  let red1 = {value = 1; color = Red; effect = NoEffect; id = 41}
  let red2 = {value = 2; color = Red; effect = NoEffect; id = 42}
  let red3 = {value = 3; color = Red; effect = NoEffect; id = 43}
  let red4 = {value = 4; color = Red; effect = NoEffect; id = 44}
  let red5 = {value = 5; color = Red; effect = NoEffect; id = 45}
  let red6 = {value = 6; color = Red; effect = NoEffect; id = 46}
  let red7 = {value = 7; color = Red; effect = NoEffect; id = 47}
  let red8 = {value = 8; color = Red; effect = NoEffect; id = 48}
  let red9 = {value = 9; color = Red; effect = NoEffect; id = 49}
  let redplus = {value = -1; color = Red; effect = Plus; id = 54}
  let redskip = {value = -1; color = Red; effect = Skip; id = 64}
  let redrev= {value = -1; color = Red; effect = Reverse; id = 74}
  (*yellow *)
  let yellow0 = {value = 0; color = Yellow; effect = NoEffect; id = 10}
  let yellow1 = {value = 1; color = Yellow; effect = NoEffect; id = 11}
  let yellow2 = {value = 2; color = Yellow; effect = NoEffect; id = 12}
  let yellow3 = {value = 3; color = Yellow; effect = NoEffect; id = 13}
  let yellow4 = {value = 4; color = Yellow; effect = NoEffect; id = 14}
  let yellow5 = {value = 5; color = Yellow; effect = NoEffect; id = 15}
  let yellow6 = {value = 6; color = Yellow; effect = NoEffect; id = 16}
  let yellow7 = {value = 7; color = Yellow; effect = NoEffect; id = 17}
  let yellow8 = {value = 8; color = Yellow; effect = NoEffect; id = 18}
  let yellow9 = {value = 9; color = Yellow; effect = NoEffect; id = 19}
  let yellowplus = {value = -1; color = Yellow; effect = Plus; id = 51}
  let yellowskip = {value = -1; color = Yellow; effect = Skip; id = 61}
  let yellowrev = {value = -1; color = Yellow; effect = Reverse; id = 71}
  (* green *)
  let green0 = {value = 0; color = Green; effect = NoEffect; id = 20}
  let green1 = {value = 1; color = Green; effect = NoEffect; id = 21}
  let green2 = {value = 2; color = Green; effect = NoEffect; id = 22}
  let green3 = {value = 3; color = Green; effect = NoEffect; id = 23}
  let green4 = {value = 4; color = Green; effect = NoEffect; id = 24}
  let green5 = {value = 5; color = Green; effect = NoEffect; id = 25}
  let green6 = {value = 6; color = Green; effect = NoEffect; id = 26}
  let green7 = {value = 7; color = Green; effect = NoEffect; id = 27}
  let green8 = {value = 8; color = Green; effect = NoEffect; id = 28}
  let green9 = {value = 9; color = Green; effect = NoEffect; id = 29}
  let greenplus = {value = -1; color = Green; effect = Plus; id = 52}
  let greenskip = {value = -1; color = Green; effect = Skip; id = 62}
  let greenrev = {value = -1; color = Green; effect = Reverse; id = 72}
  (* blue *)
  let blue0 = {value = 0; color = Blue; effect = NoEffect; id = 30}
  let blue1 = {value = 1; color = Blue; effect = NoEffect; id = 31}
  let blue2 = {value = 2; color = Blue; effect = NoEffect; id = 32}
  let blue3 = {value = 3; color = Blue; effect = NoEffect; id = 33}
  let blue4 = {value = 4; color = Blue; effect = NoEffect; id = 34}
  let blue5 = {value = 5; color = Blue; effect = NoEffect; id = 35}
  let blue6 = {value = 6; color = Blue; effect = NoEffect; id = 36}
  let blue7 = {value = 7; color = Blue; effect = NoEffect; id = 37}
  let blue8 = {value = 8; color = Blue; effect = NoEffect; id = 38}
  let blue9 = {value = 9; color = Blue; effect = NoEffect; id = 39}
  let blueplus = {value = -1; color = Blue; effect = Plus; id = 53}
  let blueskip = {value = -1; color = Blue; effect = Skip; id = 63}
  let bluerev = {value = -1; color = Blue; effect = Reverse; id = 73}
   (*the four wilds*)
  let wild = {value = -1; color = Black; effect = Wild; id = 80}
   (*the four wilds +4*)
  let wildplus = {value = -1; color = Black; effect = Wild4; id = 90}


let bluehand = [blue0;blue1;blue2;yellow0]
(* let queue1 = (Queue.create ());
  Queue.add card1 queue1; *)

  let tests = [

    "co1" >:: (fun _ -> assert_equal Player.Blue (call_color bluehand));

    (* "lst1" >:: (fun _ -> assert_equal [card6;card5;card2;card1] (get_possible_list hand1 top_card0 []));
    "nlst" >:: (fun _ -> assert_equal [] (get_possible_list hand3 top_card1 []));
    "lst2" >:: (fun _ -> assert_equal [card12;card11;card8;card7;card6;card2] (get_possible_list hand4 top_card4 []));
    "lst3" >:: (fun _ -> assert_equal [card12;card11;card5;card1] (get_possible_list hand4 top_card2 []));
    "lst4" >:: (fun _ -> assert_equal [card12;card11;card10;card8;card3] (get_possible_list hand4 card8 [])); *)

    "cc1" >:: (fun _ -> assert_equal (1,1,2,2,0) (color_count hand1 (0,0,0,0,0)));
    "cc2" >:: (fun _ -> assert_equal (1,1,2,1,0) (color_count hand2 (0,0,0,0,0)));
    "cc3" >:: (fun _ -> assert_equal (1,0,0,0,0) (color_count hand3 (0,0,0,0,0)));
    "cc4" >:: (fun _ -> assert_equal (3,2,3,2,2) (color_count hand4 (0,0,0,0,0)));

    "mc1" >:: (fun _ -> assert_equal (Blue) (most_color (color_count hand1 (0,0,0,0,0))));
    "mc2" >:: (fun _ -> assert_equal (Blue) (most_color ((color_count hand2 (0,0,0,0,0)))));
    "mc3" >:: (fun _ -> assert_equal (Yellow) (most_color ((color_count hand3 (0,0,0,0,0)))));
    "mc4" >:: (fun _ -> assert_equal (Yellow) (most_color ((color_count hand4 (0,0,0,0,0)))));


    "playable1" >:: (fun _ -> assert_equal (true) (check_playability Red red1 red5));
    "playable2" >:: (fun _ -> assert_equal (true) (check_playability Red redplus redskip));
    "playable3" >:: (fun _ -> assert_equal (true) (check_playability Blue blue5 bluerev));
    "playable4" >:: (fun _ -> assert_equal (true) (check_playability Yellow yellowplus yellow0));

    (* "play_44" >:: (fun _ -> assert_equal (Play card1) (dumbai_choose_card top_card0 hand1));
    "play_35" >:: (fun _ -> assert_equal (Play card2) (dumbai_choose_card top_card0 hand2));
    "play_22" >:: (fun _ -> assert_equal (Play card4) (dumbai_choose_card top_card1 hand1));
    "play_46" >:: (fun _ -> assert_equal (Play card5) (dumbai_choose_card top_card2 hand2));
    "play_-1" >:: (fun _ -> assert_equal (Draw) (dumbai_choose_card top_card0 hand3)); *)

    "command_1" >:: (fun _ -> assert_equal "54" (get_args "Play    54"));
    "command_2" >:: (fun _ -> assert_equal "54" (get_args "play 54"));
    "command_3" >:: (fun _ -> assert_equal "" (get_args "Info"));
    "command_4" >:: (fun _ -> assert_equal "play" (get_command "PLaY    47"));
    "command_5" >:: (fun _ -> assert_equal "1" (get_args "Draw 1"));

    "command_a" >:: (fun _ -> assert_equal "red 4" (get_args "Play    red 4"));
    "command_b" >:: (fun _ -> assert_equal "yellow draw2" (get_args "Play    yellow draw2"));
    "command_c" >:: (fun _ -> assert_equal "green 0" (get_args "Play    GREEn 0"));
    "command_d" >:: (fun _ -> assert_equal "black wild" (get_args "Play BLACK WILD"));
    "command_e" >:: (fun _ -> assert_equal "blue reverse" (get_args "Play blue Reverse"));

    (* "command_6" >:: (fun _ -> assert_equal (Plus) (det_effect 55));
    "command_7" >:: (fun _ -> assert_equal (Skip) (det_effect 69));
    "command_8" >:: (fun _ -> assert_equal (Reverse) (det_effect 70));
    "command_9" >:: (fun _ -> assert_equal (NoEffect) (det_effect 15));
    "command_x" >:: (fun _ -> assert_equal (NoEffect) (det_effect 80)); *)

    "parse_1" >:: (fun _ -> assert_equal (Play card1) (parse "play 44"));
    "parse_2" >:: (fun _ -> assert_equal (NA) (parse "play 235235"));
    "parse_3" >:: (fun _ -> assert_equal (Play card2) (parse "play 35"));
    "parse_4" >:: (fun _ -> assert_equal (Play card5) (parse "play 46"));
    "parse_5" >:: (fun _ -> assert_equal (Play card3) (parse "play 18"));

    "parse_a" >:: (fun _ -> assert_equal (Play card1) (parse "Play red 4"));
    "parse_b" >:: (fun _ -> assert_equal (Play card3) (parse "Play yeLLoW 8"));
    "parse_c" >:: (fun _ -> assert_equal (Play card4) (parse "Play       gReen 2"));
    "parse_d" >:: (fun _ -> assert_equal (NA) (parse "Play 4 red "));
    "parse_e" >:: (fun _ -> assert_equal (NA) (parse "Play wild"));

    "user_hand" >:: (fun _ -> assert_equal 7 (List.length (user_hand init_state)));
    "ai1_hand" >:: (fun _ -> assert_equal 7 (List.length (ai1_hand init_state)));
    "ai2_hand" >:: (fun _ -> assert_equal 7 (List.length (ai2_hand init_state)));
    "ai3_hand" >:: (fun _ -> assert_equal 7 (List.length (ai3_hand init_state)));

    "next_turn" >:: (fun _ -> assert_equal 1 (next_turn (init_state)));
    "draw_pile_length" >:: (fun _ -> assert_equal 79 (Queue.length (draw_pile init_state)));
  ]

let suite = "Uno test suite" >::: tests

let _ = run_test_tt_main suite
