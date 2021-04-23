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
				var computerlocationyoffset = computerlocationy + (i*2);
				var card = deck[|0];				
				ds_list_add(hand_computer, card);
				//card.iscomputercard = true;
				card.target_x = computerlocationx;
				card.target_y = computerlocationyoffset;
				card.depth = deck_size + i;
				audio_play_sound(snd_card, 1, false);
				//show_debug_message("1st place");				
				
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
				var playerlocationyoffset = playerlocationy - (i*2);
				var card = deck[|0];				
				ds_list_add(hand_player, card);
				card.target_x = playerlocationx;
				card.target_y = playerlocationyoffset;
				card.depth = deck_size + i;
				audio_play_sound(snd_card, 1, false);
				//show_debug_message("1st place");				
				
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
	//computer will place top card in the middle
	/*hand_computer[|0] = centerCard;
	hand_computer[|0].target_x = centerlocationx;
	hand_computer[|0].target_y = centerlocationy;*/
	waittimer++;
	computerLast = false;
	computerslap = false;
	
	if(waittimer == 50)
	{
		if(hasDealt == false)
		{
			var playedCard = hand_computer[|0];
			centerCard = playedCard;
			ds_list_add(middle_pile, centerCard);
			ds_list_delete(hand_computer, 0);
			
			centerCard.target_x = centerlocationx;
			centerCard.target_y = centerlocationy;	
			centerCard.depth = ds_list_size(middle_pile) * -1;
			hasDealt = true;
			show_debug_message("this should be working");
			show_debug_message(ds_list_size(middle_pile));
		}		
	}
	
		/*var computer_pick = random_range(0,2);
		playedcard_computer = hand_computer[|computer_pick]; //computer chooses card
		playedcard_computer.target_y += 100;	
		audio_play_sound(snd_card, 1, false);*/
	
	if(waittimer == 60)
	{
		waittimer = 0;	
		playerLast = false;
		computerLast = true;
		global.current_phase = global.phase_faceup;
	}	
	
	break;		
	
	case global.phase_player_chooses:
	playerLast = false;
	computerslap = false;
	
	var card = hand_player[|0];
	if(position_meeting(mouse_x, mouse_y, card)) //hover
	{
		if(mouse_check_button_pressed(mb_left))
		{
			centerCard = card; //choose the card
			ds_list_add(middle_pile, centerCard);
			ds_list_delete(hand_player, 0);
			
			centerCard.target_x = centerlocationx;
			centerCard.target_y = centerlocationy;
			centerCard.depth = ds_list_size(middle_pile) *-1;
			reveal_timer = 2 * room_speed;
			playerLast = true;
			computerLast = false;
			global.current_phase = global.phase_faceup;
			audio_play_sound(snd_card, 1, false);
		}
		//card.target_y -= 50;
		selected_card = card;	
		card.target_y = hoveroffset; //hover the card 
	}
		
	else
	{
		card.target_y = 800;	
	}	
	
	
	if(selected_card != noone)
	{
		if(selected_card.canbeselected == false)
		{
		selected_card = noone;	
		}
	}		
	
	
	break;
	
	case global.phase_faceup:
	reveal_timer--;
	
	//flip the computer's card
		
	show_debug_message("revealing card");
	
	
	if(reveal_timer == 0)
	{
		centerCard.face_up = true;
		global.current_phase = global.phase_slap;
	}
		
	break;
	
	case global.phase_slap:
	//computer will evaluate if the centerCard is the card
	//randomtimer for computer to decide
	computerdecideTimer = irandom_range(slapminTime, slapmaxTime);		
	computerslaptimer++;
	
	//Player Slaps
		if(keyboard_check_pressed(vk_space))
		{
			playerslap = true;	
		}

	if(playerslap)
	{
		playerslaptimer++	
		if(centerCard.type = global.knives)
		{
			goodslap = true;	
			badslap = false;
			global.current_phase = global.phase_evaluate;
		}
	
		else
		{
			badslap = true;	
			goodslap = false;
			global.current_phase = global.phase_evaluate;
		}
	}

	if(playerslaptimer == 60)
	{
		playerslaptimer = 0;	
	}
	
	//Computer Slaps
	if(computerslaptimer >= computerdecideTimer)
	{
		if(centerCard.type == global.knives)
		{
			computerslap = true;	
			computerslaptimer = 0;
			global.current_phase = global.phase_evaluate;
		}
		
		else
		{
			computerslap = false;	
		}
	}
	if(centerCard.type != global.knives)
	{
		gapTimer++
			
		if(gapTimer == 3* room_speed)
		{
			gapTimer = 0;
			if(computerLast)
			{
				global.current_phase = global.phase_player_chooses;	
			}
			
			else if(playerLast)
			{
				global.current_phase = global.phase_computer_chooses;	
			}
		}
	}
	
	
	break;
			
	case global.phase_evaluate:
	
	
	
	if(playerLast && centerCard.type != global.knives) //player went last and card wasn't a knife
	{
		show_debug_message("computer goes again");
		global.current_phase = global.phase_turndecide;	
	}
	
	if(goodslap)
	{
		//deals card to computer
		
		if (moveTimer%4 == 0)
		{
			for(i = 0; i < ds_list_size(middle_pile); i ++)
			{
				 var card = middle_pile[|i];  
			}
			
			show_debug_message("player slaps knives");
            var index = ds_list_size(middle_pile)-1;    //this gives us the index of the last card on the discard pile
           // var card = middle_pile[| index];            //this gives us the actual last card object on the discard pile
            
			show_debug_message(ds_list_size(middle_pile));
            card.face_up = false;                            //set it back to face down
            card.target_x = computerlocationx;                                    //set the card target_x back to the draw deck x position
            card.target_y = computerlocationy - 2*ds_list_size(hand_computer);         //set the card target_y back to the draw deck y position
            card.depth = deck_size - ds_list_size(hand_computer);        //set the card depth according to how many cards are in the deck
			    
            ds_list_add(hand_computer,card);                            //add that card to the deck
            ds_list_delete(middle_pile, index);            //and delete it from the discard pile
			computerslap = false;
			playerslap = false;
			goodslap = false;
			show_debug_message("slap1");
			global.current_phase = global.phase_turndecide;
            }       
        }	
	
	else if(badslap)
	{
		
		//deals card to player
		if (moveTimer%4 == 0)
		{
						
			for(i = 0; i < ds_list_size(middle_pile); i ++)
			{
				 var card = middle_pile[|i];  
			}
			
            //var index = ds_list_size(middle_pile)-1;    //this gives us the index of the last card on the discard pile
            var card = middle_pile[| index];            //this gives us the actual last card object on the discard pile
                           
            card.face_up = false;                            //set it back to face down
            card.target_x = playerlocationx;                                    //set the card target_x back to the draw deck x position
            card.target_y = playerlocationy - 2*ds_list_size(hand_player);         //set the card target_y back to the draw deck y position
            card.depth = deck_size - ds_list_size(hand_player);        //set the card depth according to how many cards are in the deck
			     
            ds_list_add(hand_player,card);                            //add that card to the deck
            ds_list_delete(middle_pile, index);            //and delete it from the discard pile
			computerslap = false;
			playerslap = false;
			badslap = false;
			show_debug_message("slap2");
			global.current_phase = global.phase_turndecide;
           }         
     }
	
	else if(computerslap)
	{
		//deals card to player
		if (moveTimer%4 == 0)
		{
			for(i = 0; i < ds_list_size(middle_pile); i ++)
			{
				 var card = middle_pile[|i];  
			}
			
            var index = ds_list_size(middle_pile)-1;    //this gives us the index of the last card on the discard pile
           // var card = middle_pile[| index];            //this gives us the actual last card object on the discard pile
                
            card.face_up = false;                            //set it back to face down
            card.target_x = playerlocationx;                                    //set the card target_x back to the draw deck x position
            card.target_y = playerlocationy - 2*ds_list_size(hand_player);         //set the card target_y back to the draw deck y position
            card.depth = deck_size - ds_list_size(hand_player);        //set the card depth according to how many cards are in the deck
			
			ds_list_add(hand_player,card);                            //add that card to the deck
            ds_list_delete(middle_pile, index);            //and delete it from the discard pile	
			playerslap = false;
			computerslap = false;
			show_debug_message("slap3");
			global.current_phase = global.phase_turndecide;
        }    
	}		
	
	break;
		
	case global.phase_turndecide:	
	show_debug_message("stuff incoming");
	show_debug_message(centerCard);
	show_debug_message(playerLast);
	if(computerLast)
	{
		global.current_phase = global.phase_player_chooses;	
	}
	
	else if(playerLast && centerCard.type != global.knives) //player went last and card wasn't a knife
	{
		show_debug_message("computer goes again");
		global.current_phase = global.phase_computer_chooses;	
	}
	else
	{
		global.current_phase = global.phase_computer_chooses;	
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

moveTimer++;

if(moveTimer == 16)
{
	moveTimer = 0;	
}