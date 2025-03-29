extends Node2D

var sound_player = AudioStreamPlayer.new()
var geese_sound = load("res://StartScene/CutScene/geese_sound.wav")

func _ready():
	$Background/sun.play("default")
	
	$Background/cloud.speed = 0.25
	$Background/cloud2.speed = 0.25
	$Background/cloud3.speed = 0.25
	$Background/cloud4.speed = 0.25
	$Background/cloud5.speed = 0.25
	
	sound_player.stream = geese_sound
	add_child(sound_player)
	sound_player.play()


func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://StartScene/CutScene/cutscene_2.tscn")
