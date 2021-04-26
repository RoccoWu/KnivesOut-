/// @description Insert description here
// You can write your code in this editor

//setting up an enumerator for the card types
/*global.rock = 0;
global.paper = 1;
global.scissors = 2;*/
global.operator = 0;
global.phantom = 1;
global.knives = 2;

//setting the current phase that the game is in.

global.phase_dealing = 0;
global.phase_computer_chooses = 1;
global.phase_faceup = 2;
global.phase_slap = 3;
global.phase_player_chooses = 4;
global.phase_turndecide = 5;
global.phase_reshuffle = 6;
global.phase_evaluate = 7;

global.current_phase = global.phase_dealing;


deck_size = 52;//52 for deck of cards
startingHand = 26; //26 for hands
//hand_size = 3;
computerslap = false;
playerslap = false;
goodslap = false;
badslap = false;
computerLast = false;
playerLast = false;


score_player = 0;
score_computer = 0;

playedcard_player = noone;
playedcard_computer = noone;
centerCard = noone;

deck = ds_list_create();
hand_player = ds_list_create();
hand_computer = ds_list_create();
discard_pile = ds_list_create();
middle_pile = ds_list_create();

//draw and discard locations
drawlocationx = 80;
drawlocationy = 600;
discardlocationx = 730;
discardlocationy = 480;	

// computer and player card locations

computerlocationx = room_width/2 - 50;
computerlocationy = 150;


centerlocationx = room_width/2 - 50;
centerlocationy = room_height/2;

playerlocationx = room_width/2 - 50;
playerlocationy = 800;

hoveroffset = 550;

selected_card = noone;
reveal_timer = 2* room_speed;
revealing = false;
dealtimer = 0;
waittimer = 0;
playerslaptimer = 0;
computerslaptimer = 0;
hasDealt = false;
slapminTime = 0.7 * room_speed;
slapmaxTime = 2 * room_speed;
moveTimer = 0;
gapTimer = 3; // if the current center card is not knives and it is the computer's turn.

//setting up deck size



for(i = 0; i < deck_size; i++)
{	
	random_set_seed(current_time);
	ds_list_shuffle(deck); //shuffles the deck
	var drawlocationoffset = drawlocationy - (i*10);
	//var newcard = instance_create_depth(drawlocationx, drawlocationoffset, 1, obj_card);
	var newcard = instance_create_layer(drawlocationx, drawlocationoffset,"Instances", obj_card);
	audio_play_sound(snd_card, 1, false);
	show_debug_message(drawlocationoffset);
	show_debug_message(i+1);
	
	newcard.dealt = false;
	newcard.face_up = false;
	
	if(i < 2)
	{
		newcard.type = global.knives;

	}
	
	else if( i < (deck_size-4)/2) 
	{
		newcard.type = global.operator;

	}
	
	else
	{
		newcard.type = global.phantom;

	}
	
	//add the newcard to the deck list
	ds_list_add(deck, newcard);	
}
	
//}
//ds_list_shuffle(deck);
/*
for(i = 0; i < deck_size; i++)
{
	deck[|i].x = 40;
	deck[|i].y = 600 -(10*i);
	deck[|i].target_x = deck[|i].x;
	deck[|i].target_y = deck[|i].y;
	deck[|i].depth = deck_size - i;
	
}*/
