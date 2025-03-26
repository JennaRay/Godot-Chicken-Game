extends AnimatedSprite2D


func _ready():
	play("idle_right")

func play_walk_animation(left: bool):
	if left:
		play("walk_left")
	else: 	
		play("walk_right")

func play_idle_animation(left: bool):
	if left:
		play("idle_left")
	else:
		play("idle_right")

func play_jump_animation(left: bool):
	if left:
		play("jump_left")
	else:
		play("jump_right")
	
func play_fall_animation(left: bool):
	if left:
		play("fly_left")
	else:
		play("fly_right")

func play_duck_animation(left: bool):
	if left:
		play("duck_left")
	else:
		play("duck_right")
