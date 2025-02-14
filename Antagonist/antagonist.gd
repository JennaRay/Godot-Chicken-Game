extends CharacterBody2D

var speed = 300


func _on_interact_box_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage()
		#print("antagonist antagonized")
		
func _physics_process(delta: float) -> void:
	if $upTimer.is_stopped():
		velocity.y = 1 * speed
	elif $downTimer.is_stopped():
		velocity.y = -1 * speed
	
	move_and_slide()


func _on_up_timer_timeout() -> void:
	$downTimer.start()


func _on_down_timer_timeout() -> void:
	$upTimer.start()
