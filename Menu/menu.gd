extends Node2D

var save_file = "user://player_data.ini"
var game_save_file = "user://game_data.ini"

var avatar = 1
var numAvatars = 3

var bg_music := AudioStreamPlayer.new()
var sound_player := AudioStreamPlayer.new()

func _ready():
	bg_music.stream = load("res://Menu/Chimken-menu.mp3")
	bg_music.autoplay = true
	add_child(bg_music)
	add_child(sound_player)

func switch_avatar(num: int):
	avatar += num
	if avatar > numAvatars: 
		avatar = 1
	if avatar <= 0:
		avatar = numAvatars
		
func _process(delta: float) -> void:
	match avatar:
		1:
			%chicken1.visible = true
			%chicken2.visible = false
			%chicken3.visible = false
			
			%chicken1.play("default")
		2: 
			%chicken1.visible = false
			%chicken2.visible = true
			%chicken3.visible = false
			
			%chicken2.play("idle_right")
		3:
			%chicken1.visible = false
			%chicken2.visible = false
			%chicken3.visible = true
			
			%chicken3.play("default")

	
		

func _on_left_arrow_pressed() -> void:
	var sound_effect = load("res://Menu/chicken-noise-196746.mp3")
	sound_player.stream = sound_effect
	sound_player.play()

	switch_avatar(-1)


func _on_right_arrow_pressed() -> void:
	var sound_effect = load("res://Menu/chicken-noise-196746.mp3")
	sound_player.stream = sound_effect
	sound_player.play()

	switch_avatar(1)


func _on_start_btn_pressed() -> void:
	var sound_effect = load("res://Menu/rooster-cry-173621.mp3")
	sound_player.stream = sound_effect
	sound_player.play()
	
	set_up_file()
	save_choice()
	get_tree().change_scene_to_file("res://main.tscn")

func set_up_file():
	var config_file = ConfigFile.new()
	config_file.set_value("Inventory", "slot1", {"image_path" : "", "name": ""})
	config_file.set_value("Inventory", "slot2", {"image_path" : "", "name": ""})
	config_file.set_value("Inventory", "slot3", {"image_path" : "", "name": ""})
	config_file.set_value("Inventory", "slot4", {"image_path" : "", "name": ""})
	config_file.set_value("Inventory", "slot5", {"image_path" : "", "name": ""})
	config_file.set_value("Inventory", "slot6", {"image_path" : "", "name": ""})
	config_file.set_value("Workbench", "slot1", "")
	config_file.set_value("Workbench", "slot2", "")
	config_file.set_value("Workbench", "slot3", "")
	config_file.set_value("Workbench", "slot4", "")
	config_file.set_value("Player", "choice", 1)
	config_file.set_value("Player", "lives", 3)
	config_file.set_value("Player", "mainPosX", 0)
	config_file.set_value("Player", "mainPosY", 0)
	config_file.save(save_file)

func save_choice():
	var config_file := ConfigFile.new()
	var game_file := ConfigFile.new()
	var load_error = config_file.load(save_file)
	if load_error:
		print("error while loading file on menu ", load_error)
		return
	
	config_file.set_value("Player", "choice", avatar)
	game_file.set_value("Map", "piece", avatar)
	
	var error := config_file.save(save_file)
	game_file.save(game_save_file)
	if error:
		print("An error happened while saving data for menu: ", error)
