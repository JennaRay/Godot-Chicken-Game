extends CharacterBody2D

#player movement attributes
var speed = 600
var jump_strength = 500
var gravity = 1000
var health = 3
signal health_depleted

#player states
var facing_left = true
var moving = false
var dead = false
var paused = false

var sound_player := AudioStreamPlayer.new()
#sound effects
var jump_sound = preload("res://Player/jump.wav")
var hurt_sound = preload("res://Player/ouch.mp3")

func _ready():
	add_child(sound_player)

func _physics_process(delta: float) -> void:
	if not paused:
		var direction = Input.get_axis("move_left", "move_right")
		velocity.x = direction * speed
		
		if not is_on_floor():
			velocity.y += gravity * delta
		
		if not dead:
			if is_on_floor():
				if Input.is_action_just_released("move_left") or Input.is_action_just_released("move_right") or Input.is_action_just_released("duck") or Input.is_action_just_released("jump"):
					moving = false
					if Input.is_action_pressed("move_left"):
						facing_left = true
						$chimken.play_walk_animation(facing_left)
						moving = true
					elif Input.is_action_pressed("move_right"):
						facing_left = false
						$chimken.play_walk_animation(facing_left)
						moving = true
					else:
						$chimken.play_idle_animation(facing_left)
						moving = false
				if Input.is_action_just_pressed("jump"):
					sound_player.stream = jump_sound
					sound_player.play()
					$chimken.play_jump_animation(facing_left)
					velocity.y =- jump_strength
					%jumpTimer.start()
					moving = false
				if Input.is_action_pressed("duck"):
					$chimken.play_duck_animation(facing_left)
				
			if Input.is_action_just_pressed("move_left"):
				facing_left = true
				$chimken.play_walk_animation(facing_left)
				moving = true
			elif Input.is_action_just_pressed("move_right"):
				facing_left = false
				$chimken.play_walk_animation(facing_left)
				moving = true
		
			move_and_slide()
		else:
			position.y += 10
			$chimken.play_fall_animation(facing_left)
		if not %kickBackTimer.is_stopped():
			$chimken.modulate = Color(1,0,0)
		else:
			$chimken.modulate = Color(1,1,1)

func pause():
	paused = true
	if not %jumpTimer.is_stopped():
		%jumpTimer.paused = true
	if not %kickBackTimer.is_stopped():
		%kickBackTimer.paused = true
	
func unpause():
	paused = false
	if %jumpTimer.paused == true:
		%jumpTimer.paused = false
	if %kickBackTimer.paused == true:
		%kickBackTimer.paused = false

func _on_jump_timer_timeout() -> void:
	if not is_on_floor():
		$chimken.play_fall_animation(facing_left)
	else: 
		if not moving:
			$chimken.play_idle_animation(facing_left)
		else:
			$chimken.play_walk_animation(facing_left)


func _on_interact_box_body_entered(body: Node2D) -> void:
	if body.has_method("collect"):
		body.collect()
		
func take_damage():
	sound_player.stream = hurt_sound
	sound_player.play()
	%kickBackTimer.start()
	health -= 1
	if health <= 0:
		health_depleted.emit()
	
	
	
