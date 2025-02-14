extends CharacterBody2D

#player movement attributes
var speed = 600
var jump_strength = 500
var gravity = 1000

#player states
var facing_left = true
var moving = false

func _ready():
	%chimken.play("idle_right")

func _physics_process(delta: float) -> void:
	
	var direction = Input.get_axis("move_left", "move_right")
	velocity.x = direction * speed
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if is_on_floor():
		if Input.is_action_just_released("move_left") or Input.is_action_just_released("move_right") or Input.is_action_just_released("duck"):
			if Input.is_action_pressed("move_left"):
				facing_left = true
				%chimken.play_walk_animation(facing_left)
				moving = true
			elif Input.is_action_pressed("move_right"):
				facing_left = false
				%chimken.play_walk_animation(facing_left)
				moving = true
			else:
				%chimken.play_idle_animation(facing_left)
				moving = false
		if Input.is_action_just_pressed("jump"):
			%chimken.play_jump_animation(facing_left)
			velocity.y =- jump_strength
			%jumpTimer.start()
		if Input.is_action_pressed("duck"):
			%chimken.play_duck_animation(facing_left)
		
	if Input.is_action_just_pressed("move_left"):
		facing_left = true
		%chimken.play_walk_animation(facing_left)
		moving = true
	if Input.is_action_just_pressed("move_right"):
		facing_left = false
		%chimken.play_walk_animation(facing_left)
		moving = true
	move_and_slide()


func _on_jump_timer_timeout() -> void:
	if not is_on_floor():
		%chimken.play_fall_animation(facing_left)
	else: 
		if not moving:
			%chimken.play_idle_animation(facing_left)


func _on_interact_box_body_entered(body: Node2D) -> void:
	if body.has_method("collect"):
		body.collect
		
func take_damage():
	print("take damage")
