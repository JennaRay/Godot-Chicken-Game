extends CharacterBody2D

var speed = 300

signal gameOver()

var sound_player = AudioStreamPlayer.new()
var honk = preload("res://Antagonist/goose/goose.mp3")

func _ready():
	$upTimer.wait_time = 1
	$downTimer.wait_time = 1
	add_child(sound_player)

func _on_interact_box_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		sound_player.stream = honk
		sound_player.play()
		body.take_damage()
		gameOver.emit()
		
func _physics_process(_delta: float) -> void:
	if $upTimer.is_stopped():
		velocity.x = 1 * speed
		$AnimatedSprite2D.play("walk_right")
	elif $downTimer.is_stopped():
		velocity.x = -1 * speed
		$AnimatedSprite2D.play("walk_left")
	
	move_and_slide()


func _on_up_timer_timeout() -> void:
	$downTimer.start()


func _on_down_timer_timeout() -> void:
	$upTimer.start()
