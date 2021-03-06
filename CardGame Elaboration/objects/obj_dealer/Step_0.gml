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
				card.target_x = computerlocationx;
				card.target_y = computerlocationyoffset;
				card.depth = i;
				audio_play_sound(snd_card, 1, false);
				//show_debug_message("1st place");				
				
				ds_list_delete(deck,0)
			}
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
				card.depth = i;
				audio_play_sound(snd_card, 1, false);
				//show_debug_message("1st place");				
				
				ds_list_delete(deck,0);

			//animation
			
			}
			
	}
	waittimer = 0;
	global.current_phase = global.phase_computer_chooses;
	
	break;
	
	case global.phase_computer_chooses:
	//computer will place top card in the middle
	
	waittimer++;
	computerLast = false;
	computerslap = false;
	hasDealt = false;
	
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
			reveal_timer = 2 * room_speed;
			show_debug_message("this should be working");
			show_debug_message(ds_list_size(middle_pile));
		}		
	}
			
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
		card.depth = -9999; //sets the card to be on the top depth
		card.target_y = hoveroffset; //hover the card 
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
	computerslaptimer = 0;
	show_debug_message(reveal_timer);
	reveal_timer--;
	
	//flip the computer's card
		
	//show_debug_message("revealing card");
	
	
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
		if(centerCard.type == global.knives)
		{
			audio_play_sound(snd_knives, 1, false);
			goodslap = true;	
			badslap = false;
			global.current_phase = global.phase_evaluate;
		}
		
	
		else if(centerCard.type == global.operator)
		{
			audio_play_sound(snd_operator, 1, false);
			badslap = true;	
			goodslap = false;
			global.current_phase = global.phase_evaluate;
		}
		
		else if(centerCard.type == global.phantom)
		{
			audio_play_sound(snd_phantom, 1, false);
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
			audio_play_sound(snd_knives, 1, false);
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
	show_debug_message("moveTimer:");
	show_debug_message(moveTimer);
	computerslaptimer = 0;
	playerslaptimer = 0;	
	
	if(playerLast && centerCard.type != global.knives) //player went last and card wasn't a knife
	{
		show_debug_message("computer goes again");		
	}
	
	if(goodslap)
	{
		//deals card to computer			
		if (moveTimer%4 == 0)
		{
			show_debug_message("goodslap");
			show_debug_message(ds_list_size(middle_pile));
			
			for(i = 0; i < ds_list_size(hand_computer); i ++)
			{
				 var cardComputer = hand_computer[|i]; 
				 cardComputer.depth -=1;
			}
			
			show_debug_message("player slaps knives");
            var index = ds_list_size(middle_pile)-1;    //this gives us the index of the last card on the discard pile           
            var card = middle_pile[| index];            //this gives us the actual last card object on the discard pile
            
			show_debug_message(ds_list_size(middle_pile));
            card.face_up = false;                            //set it back to face down
            card.target_x = computerlocationx;                                    //set the card target_x back to the draw deck x position
            card.target_y = computerlocationy + 2*ds_list_size(hand_computer);         //set the card target_y back to the draw deck y position
            card.depth = ds_list_size(hand_computer) +1;        //set the card depth according to how many cards are in the deck
			    
            ds_list_add(hand_computer,card);                            //add that card to the deck
            ds_list_delete(middle_pile, index);            //and delete it from the discard pile			
			show_debug_message("slap1");
			//global.current_phase = global.phase_turndecide;
            }       
        }	
	
	else if(badslap)
	{
		
		//deals card to player
		if (moveTimer%4 == 0)
		{
			
			for(i = 0; i < ds_list_size(hand_player); i ++)
			{
				 var cardPlayer = hand_player[|i]; 
				 cardPlayer.depth -=1;
			}
			
			show_debug_message("badslap");	
			show_debug_message(ds_list_size(middle_pile));
			
            var index = ds_list_size(middle_pile)-1;    //this gives us the index of the last card on the discard pile
            var card = middle_pile[| index];            //this gives us the actual last card object on the discard pile
                           
            card.face_up = false;                            //set it back to face down
            card.target_x = playerlocationx;                                    //set the card target_x back to the draw deck x position
            card.target_y = playerlocationy - 2*ds_list_size(hand_player);         //set the card target_y back to the draw deck y position
            card.depth = ds_list_size(hand_player) +1;        //set the card depth according to how many cards are in the deck
			     
            ds_list_add(hand_player,card);                            //add that card to the deck
            ds_list_delete(middle_pile, index);            //and delete it from the discard pile			
			show_debug_message("slap2");			
           }         
     }
	
	else if(computerslap)
	{
		//deals card to player
		if (moveTimer%4 == 0)
		{
			for(i = 0; i < ds_list_size(hand_player); i ++)
			{
				 var cardPlayer = hand_player[|i]; 
				 cardPlayer.depth -=1;
			}
			
			show_debug_message("computerslap");
			show_debug_message(ds_list_size(middle_pile));			
		
             var index = ds_list_size(middle_pile)-1;    //this gives us the index of the last card on the discard pile
             var card = middle_pile[| index];            //this gives us the actual last card object on the discard pile
                
            card.face_up = false;                            //set it back to face down
            card.target_x = playerlocationx;                                    //set the card target_x back to the draw deck x position
            card.target_y = playerlocationy - 2*ds_list_size(hand_player);         //set the card target_y back to the draw deck y position
            card.depth = ds_list_size(hand_player) + 1;        //set the card depth according to how many cards are in the deck
			
			ds_list_add(hand_player,card);                            //add that card to the deck
            ds_list_delete(middle_pile, index);            //and delete it from the discard pile				
			show_debug_message("slap3");			
        }    
	}		
	
	else 
	{
		
	}
	
	if(ds_list_size(middle_pile) == 0 )
	{
		show_debug_message("no more cards in middle pile");
		global.current_phase = global.phase_turndecide;	
	}
	break;
		
	case global.phase_turndecide:
	computerslap = false;
	playerslap = false;
	goodslap = false;
	badslap = false;
	show_debug_message("stuff incoming");
	show_debug_message(centerCard);
	show_debug_message(playerLast);
	show_debug_message(computerLast);
	
	if(computerLast && playerLast == false)
	{
		reveal_timer = 2* room_speed;
		global.current_phase = global.phase_player_chooses;	
	}
	
	else if(computerLast == false && playerLast) //player went last and card wasn't a knife
	{
		show_debug_message("computer goes again");
		reveal_timer = 2* room_speed;
		global.current_phase = global.phase_computer_chooses;
	}
	
	else
	{
		reveal_timer = 2* room_speed;
		global.current_phase = global.phase_computer_chooses;	
	}
	
	break;
	
	case global.phase_reshuffle:
	show_debug_message("reshuffling");	
		
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
		
		if(ds_list_size(discard_pile) = 0)
		{
			global.current_phase = global.phase_dealing;
		}
			
	break;
}

moveTimer++;

if(moveTimer == 16)
{
	moveTimer = 0;	
}