/// @description Insert description here
// You can write your code in this editor

if(ds_list_size(obj_dealer.hand_player) = 0)
{
	playerWins = true;
}

else if(ds_list_size(obj_dealer.hand_computer) = 0)
{
	computerWins = true;	
}


if(playerWins)
{
	room_goto(PlayerWins);
}

else if(computerWins)
{
	room_goto(ComputerWins);
}

