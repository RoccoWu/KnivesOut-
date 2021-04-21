/// @description Insert description here
// You can write your code in this editor

//show_debug_message(global.current_phase);
switch(global.current_phase)
{
	case global.phase_dealing:
	ds_list_shuffle(deck); //shuffles the deck	
	if(ds_list_size(hand_computer) < startingHand) //deals cards to the computer
	{				
			for(i=0; i < startingHand; i++)			
			{
				var computerlocationyoffset = computerlocation2y + (i*2);
				var card = deck[|0];				
				ds_list_add(hand_computer, card);
				//card.iscomputercard = true;
				card.target_x = computerlocation2x;
				card.target_y = computerlocationyoffset;
				card.depth = deck_size + i;
				audio_play_sound(snd_card, 1, false);
				show_debug_message("1st place");
				
				
				ds_list_delete(deck,0)
			}
			
		
		/*card[0].x = lerp(card.x,computerlocation1x, 0.1);
		card[0].y = lerp(card.y,computerlocation1y, 0.1);
		card[1].x = lerp(card.x,computerlocation2x, 0.1);
		card[1].y = lerp(card.y,computerlocation2y, 0.1);
		card[2].x = lerp(card.x,computerlocation3x, 0.1);
		card[2].y = lerp(card.y,computerlocation3y, 0.1);*/
			
			//animation
	}
	
	if(ds_list_size(hand_player) < startingHand) //deals cards to the player
	{
		for(i=0; i < startingHand; i++)
			{
				var playerlocationyoffset = playerlocation2y - (i*2);
				var card = deck[|0];				
				ds_list_add(hand_player, card);
				card.target_x = playerlocation2x;
				card.target_y = playerlocationyoffset;
				card.depth = deck_size + i;
				audio_play_sound(snd_card, 1, false);
				show_debug_message("1st place");
				
				
				ds_list_delete(deck,0);

			//animation
			
		}
			//for(i = 0; i < hand_size; i++)
			//{
			//	hand_player[| i].face_up = true;	
			//	show_debug_message("card face up");				
			//}			
			
	}
	
	
	global.current_phase = global.phase_computer_chooses;
	
	break;
	
	case global.phase_computer_chooses:
	
	/*hand_computer[|0] = centerCard;
	hand_computer[|0].target_x = centerlocationx;
	hand_computer[|0].target_y = centerlocationy;*/
	waittimer++;
	
	if(waittimer == 50)
	{
		for( i = 0; i <1; i++)
		{
			var playedCard = hand_computer[|0];
			playedCard = centerCard;
			if(i == 0)
				{
					playedCard.target_x = centerlocationx;
					playedCard.target_y = centerlocationy;	
				}
		}
	
		/*var computer_pick = random_range(0,2);
		playedcard_computer = hand_computer[|computer_pick]; //computer chooses card
		playedcard_computer.target_y += 100;	
		audio_play_sound(snd_card, 1, false);*/
	}
	
	if(waittimer == 60)
	{
		waittimer = 0;	
		global.current_phase = global.phase_player_chooses;
	}
	
	
	break;		
	
	case global.phase_player_chooses:
	
	//if(selected_card  && selected_card.iscomputercard == false)
	//{
	//	selected_card.target_y += 50;	
		
	//}
	for(i=0; i < hand_size; i++)
	{
		var card = hand_player[|i];
		if(position_meeting(mouse_x, mouse_y, card)) //hover
		{
			if(mouse_check_button_pressed(mb_left))
			{
				playedcard_player = selected_card; //choose the card
				reveal_timer = 2 * room_speed;
				global.current_phase = global.phase_play;
				audio_play_sound(snd_card, 1, false);
			}
			//card.target_y -= 50;
			selected_card = card;	
			card.target_y = hoveroffset; //hover the card 
		}
		
		else
		{
			card.target_y = 600;	
		}
	}
	
	
	if(selected_card != noone)
	{
		if(selected_card.canbeselected == false)
		{
		selected_card = noone;	
		}
	}		
	
	
	break;
	
	case global.phase_play:
	reveal_timer--;
	
	//flip the computer's card
	
	playedcard_computer.face_up = true;
	
	if(reveal_timer == 0)
	{
		global.current_phase = global.phase_result;
	}
		
	break;
	
	case global.phase_result:
		var result = CompareCards(playedcard_computer.type, playedcard_player.type); //compare the cards and assign a winner and loser
		switch (result) {
			case 0: //if tie
			score_computer += 0;
			score_player += 0;
			//show_debug_message("tie");
			  break;
			case 1: //if computer wins
			score_computer += 1;
			score_player += 0;
			audio_play_sound(snd_lose, 1, false);
			//show_debug_message("tie");
			  break;
			case -1: //if player wins
			score_computer += 0;
			score_player += 1;
			audio_play_sound(snd_win, 1, false);
			  break;
		}		
	global.current_phase = global.phase_discard;
	break;
	
	case global.phase_discard:
	//var drawlocationoffset = drawlocationy - (i*10);
	//for(i=0; i <hand_size; i++)
	//{
	//	hand_player[|i].face_up = true;		
	//	hand_player[|i].target_x = discardlocationx;
	//	hand_player[|i].target_y = discardlocationy;
	//	hand_player[|i].canbeselected = false;	
	//	ds_list_add(discard_pile, hand_player[|i]);
	//}
	//hand_computer.target_x = discardlocationx;
	//hand_computer.target_y = discardlocationy;
	//hand_player.target_x = discardlocationx;
	//hand_player.target_y = discardlocationy;	
	//playedcard_computer.target_x = discardlocationx;
	//playedcard_computer.target_y = discardlocationy;
	//playedcard_player.target_x = discardlocationx;
	//playedcard_player.target_y = discardlocationy;
	
	
	for(i =0; i < hand_size; i++)
	{
		hand_computer[|i].face_up = true;		
		hand_computer[|i].target_x = discardlocationx; //bring all of the cards from the computer's hand to discard location
		hand_computer[|i].target_y = discardlocationy;
		hand_computer[|i].canbeselected = false;	
		ds_list_add(discard_pile, hand_computer[|i]);
		//ds_list_clear(hand_computer);
		
	}
	
	for(i =0; i < 3; i++)
	{	
		hand_player[|i].selected_card = false; 
		hand_player[|i].target_x = discardlocationx; //bring all of the cards from the player's hand to discard location
		hand_player[|i].target_y = discardlocationy;
		hand_player[|i].canbeselected = false;
		ds_list_add(discard_pile, hand_player[|i]);
		//ds_list_clear(hand_computer);
		
	}
	ds_list_clear(hand_computer); //clear the computer's hand
	ds_list_clear(hand_player); //clear the player's hand
	
	
	for(i = 0; i < hand_computer; i++)
	{
		//hand_computer = ds_li
	}
	
	if(ds_list_size(deck) = 0)
	{
		//ds_list_clear(hand_computer);
		//ds_list_clear(hand_player);
		global.current_phase = global.phase_reshuffle;
		show_debug_message("reshuffling");
	}
	
	else
	{
		global.current_phase = global.phase_dealing;
		show_debug_message("dealing again");
		
	}	
	
	break;
	
	case global.phase_reshuffle:
	show_debug_message("reshuffling");
	//dealtimer++;
	
	//ds_list_copy(deck, discard_pile);
	//ds_list_clear(discard_pile);
	//for(i=0; i < deck_size; i++)
	//{
	//	instance_destroy(discard_pile[|i]);	
	//}
	
	//if(dealtimer > 6)
	//{
		while(ds_list_size(discard_pile) >0)
		{	
			
			var card = discard_pile[|0];
			ds_list_delete(discard_pile, 0); //remove the card from the discard pile
			ds_list_add(deck, card); //add the card to the deck
			card.face_up = false; //make the card show the back side
			card.target_x = drawlocationx;	//reposition cards to the initial drawlocation x value		
			card.target_y = drawlocationy - (10*ds_list_size(deck)); //reposition the cards to different spread
			card.depth = ds_list_size(deck); //set the depth of each card
			card.canbeselected = true; //set the cards back to canbeselected so it is not null
			show_debug_message("deck size:");
			show_debug_message(ds_list_size(deck));		
			
		}
		/*
		for(i = 0; i < deck_size; i++)
			{
				var card = deck[|i];
				card.target_y = drawlocationy - (10*i);	
			}*/
		
		if(ds_list_size(discard_pile) = 0)
		{
			global.current_phase = global.phase_dealing;
		}
			//global.current_phase = global.phase_dealing;
	//}
	
	//else
	//{
	//	global.current_phase = global.phase_dealing;	
	//}
	break;
}
