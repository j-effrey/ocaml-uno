# uno
Uno for 3110

#TODO:
[Done, below is for reference only]
GUI click to play card implementation:
Instead of read_line for the repl loop when its the human's turn, wait for a mouse button down
action.
Separate function, state -> command
If the mouse_button down action does not have coordinates within either the human's hand or
the draw pile, then no response. If it has coordinates within the draw pile, then convert it to
a draw command.  If the coordinates are within the human hand, convert human's hand, and then
convert the coordinates to a specific (Play card) command.
