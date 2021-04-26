/// @description Insert description here
// You can write your code in this editor

draw_set_font(font_title);
draw_text(room_width/2-140,  200, string("Knives Out!"));

draw_set_font(font_tutorialtitle);
draw_text(room_width/2-110,  400, string("How to Play"));
draw_set_font(font_tutorial);
draw_text(5, 500, string("1. The player and computer will take turn drawing a card from"));
draw_text(5, 530, string(" their hand face down."));
draw_text(5, 560, string("2. The goal is to deplete your hand by slapping the middle"));
draw_text(5, 590, string("pile when the current played card is the correct type of card."));
draw_text(5, 620, string("3. Here are the types of cards:"));
draw_text(125, 850, string("Slap this!"));
draw_text(460, 850, string("Do NOT slap this!"));


draw_set_font(font_tutorialtitle);
draw_text(room_width/2-180,  900, string("Press space to start!"));