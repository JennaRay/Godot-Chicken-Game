extends AnimatedSprite2D


func play_walk_left_animation():
	%chimken.play("walk_left")
	
func play_walk_right_animation():
	%chimken.play("walk_right")

func play_idle_animation():
	%chimken.play("idle_right")
