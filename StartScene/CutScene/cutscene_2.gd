extends Node2D

var sound_player = AudioStreamPlayer.new()
var background_music = AudioStreamPlayer.new()
var geese_sound = load("res://StartScene/CutScene/geese_sound.wav")
var bg_music = load("res://StartScene/CutScene/inspiration.mp3")

var file_path = "user://player_data.ini"

func _ready():
	$eye1.play("default")
	$eye2.play("default")
	
	sound_player.stream = geese_sound
	background_music.stream = bg_music
	add_child(sound_player)
	add_child(background_music)
	sound_player.play()
	background_music.play()
	
	set_color()

func _process(_delta):
	$Camera2D.zoom += Vector2(0.001,0.001)
	
func set_color():
	var config_file = ConfigFile.new()
	config_file.load(file_path)
	var choice = config_file.get_value("Player", "choice", 1)
	
	if choice == 2:
		$ColorRect.color = Color(.10, .10, .10)
	if choice == 3:
		$ColorRect.color = Color(.5,.89,.6)


func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://main.tscn")
