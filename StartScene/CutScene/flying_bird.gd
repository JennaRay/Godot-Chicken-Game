extends AnimatedSprite2D

func _ready():
	var timer_length = randf_range(0, 0.2)
	$startTimer.wait_time = timer_length
	$startTimer.start()
	
func _process(_delta):
	position.x -= 0.1
	position.y -= 0.1


func _on_start_timer_timeout() -> void:
	play("default")
