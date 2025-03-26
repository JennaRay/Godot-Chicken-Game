extends CharacterBody2D

var speed = 300

signal gameOver()

var sound_player = AudioStreamPlayer.new()
var quack = preload("res://Antagonist/duck/duck.mp3")

func _ready():
	$AnimatedSprite2D.play("default")
	add_child(sound_player)

func _on_interact_box_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		sound_player.stream = quack
		sound_player.play()
		body.take_damage()
		gameOver.emit()
		
func _physics_process(_delta: float) -> void:
	if not $upTimer.is_stopped():
		velocity.y = 1 * speed
	elif not $downTimer.is_stopped():
		velocity.y = -1 * speed
	else:
		velocity.y = 0
	
	move_and_slide()


func _on_up_timer_timeout() -> void:
	$upWait.start()


func _on_down_timer_timeout() -> void:
	$downWait.start()


func _on_up_wait_timeout() -> void:
	$downTimer.start()
	

func _on_down_wait_timeout() -> void:
	$upTimer.start()
