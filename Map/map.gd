extends Node2D

var speed = 3

func _process(delta: float) -> void:
	if Input.is_action_pressed("move_forward"):
		$foreground/Path2D/PathFollow2D.progress += 1 * 3
	if Input.is_action_pressed("duck"):
		if $foreground/Path2D/PathFollow2D.progress > 0:
			$foreground/Path2D/PathFollow2D.progress -= 1 * 3
		
		
