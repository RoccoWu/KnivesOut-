// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
// return 0: draw
// return 1: computer win
// return -1: player win
function CompareCards(cardComputer, cardPlayer){
	
	switch(cardComputer)
	{
		//if computer card is same as player card
		// case obj_dealer.playedcard_player:
		case global.rock: //computer chooses rock
			switch(cardPlayer){
				case global.paper: return -1;
				case global.rock: return 0;
				case global.scissors: return 1;
			}
		break;
		case global.paper: //computer chooses paper
			switch(cardPlayer) {
				case global.paper: return 0;
				case global.rock: return 1;
				case global.scissors: return -1;
			}
			break;
		case global.scissors: //computer chooses scissors
		switch(cardPlayer) {
				case global.paper: return 1;
				case global.rock: return -1;
				case global.scissors: return 0;
			}
		break;
		
		
	}	

}