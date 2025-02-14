extends AnimatedSprite2D


func play_walk_animation(left: bool):
	if left:
		%chimken.play("walk_left")
	else: 	
		%chimken.play("walk_right")

func play_idle_animation(left: bool):
	if left:
		%chimken.play("idle_left")
	else:
		%chimken.play("idle_right")

func play_jump_animation(left: bool):
	if left:
		%chimken.play("jump_left")
	else:
		%chimken.play("jump_right")
	
func play_fall_animation(left: bool):
	if left:
		%chimken.play("fly_left")
	else:
		%chimken.play("fly_right")

func play_duck_animation(left: bool):
	if left:
		%chimken.play("duck_left")
	else:
		%chimken.play("duck_right")
