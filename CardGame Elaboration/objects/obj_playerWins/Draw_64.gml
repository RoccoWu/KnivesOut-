/// @description Insert description here
// You can write your code in this editor
draw_set_font (font_title); //sets the font
draw_set_color(c_white); //makes the player one font white
draw_text(room_width/2-150,  room_height/2, string("Player Wins!"));

draw_set_font (font_tutorial); //sets the font
draw_text(room_width/2-150,  room_height/2 +300, string("Press space to play again"));
