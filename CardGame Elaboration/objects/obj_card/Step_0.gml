/// @description Insert description here
// You can write your code in this editor

if(face_up)
{
	//show_debug_message(type);
    switch(type) {
		case global.knives: 
			sprite_index = spr_knives;
			break;
		case global.phantom:
			sprite_index = spr_phantom;
			break;
		case global.operator:
			sprite_index = spr_operator;
			break;		
	}
} 
else 
{
	sprite_index = spr_newback;
}

x = lerp(x, target_x,.05);
y = lerp(y, target_y,.05);