extends CharacterBody2D

#player movement attributes
var speed = 600
var jump_strength = 370
var gravity = 1000

#player states
var facing_left = true
var moving = false

func _physics_process(delta: float) -> void:
	
	var direction = Input.get_axis("move_left", "move_right")
	velocity.x = direction * speed
	
	if not is_on_floor:
		velocity.y += gravity * delta
	
	if is_on_floor:
		if Input.is_action_just_released("move_left") or Input.is_action_just_released("move_right"):
			if Input.is_action_pressed("move_left"):
				%chimken.play_walk_left_animation()
			elif Input.is_action_pressed("move_right"):
				%chimken.play_walk_right_animation()
			else:
				moving = false
				%chimken.play_idle_animation()
		if Input.is_action_just_pressed("jump"):
			velocity.y =- jump_strength
			moving = true
			

		
	if Input.is_action_just_pressed("move_left"):
		%chimken.play_walk_left_animation()
		moving = true
	if Input.is_action_just_pressed("move_right"):
		%chimken.play_walk_right_animation()
		moving = true
	move_and_slide()
