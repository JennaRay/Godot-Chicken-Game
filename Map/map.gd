extends Node2D

var save_file = "user://game_data.ini"

var bg_music_player = AudioStreamPlayer.new()
var bg_music = load("res://Map/where-will-you-go.mp3")


var speed = 5

var selected = 0

#states
var pond_complete = 0
var pig_complete = 0
var bull_complete = 0
var sheep_complete = 0

func _ready():
	bg_music_player.stream = bg_music
	add_child(bg_music_player)
	bg_music_player.play()
	load_map()

func _process(_delta: float) -> void:
	if Input.is_action_pressed("move_forward"):
		%follower.progress += 1 * speed
	if Input.is_action_pressed("duck"):
		if %follower.progress > 0:
			%follower.progress -= 1 * speed
	
	if Input.is_action_pressed("click") or Input.is_action_pressed("enter") or Input.is_action_just_pressed("interact"):
		if selected != 0:
			save_map()
			if selected == -1:
				get_tree().change_scene_to_file("res://main.tscn")
			if selected == 1:
				get_tree().change_scene_to_file("res://Level1/level_1.tscn")
			
func save_map():
	var config_file := ConfigFile.new()
	
	config_file.set_value("Map", "progress", %follower.progress)
	config_file.set_value("Map", "pond", pond_complete)
	config_file.set_value("Map", "pig", pig_complete)
	config_file.set_value("Map", "sheep", sheep_complete)
	config_file.set_value("Map", "bull", bull_complete)
	
	var error := config_file.save(save_file)
	if error:
		print("An error happened while saving data for map: ", error)
		
			
func load_map():
	if FileAccess.file_exists(save_file):
			
		var config_file := ConfigFile.new()
		var error := config_file.load(save_file)
		
		if error:
			print("An error happened while loading data for map: ", error)
			return
		
		%follower.progress = config_file.get_value("Map", "progress", 0)
		pond_complete = config_file.get_value("Map", "pond", 0)
		sheep_complete = config_file.get_value("Map", "sheep", 0)
		pig_complete = config_file.get_value("Map", "pig", 0)
		bull_complete = config_file.get_value("Map", "bull", 0)
	else:
		save_map()
		print("new file created")
	
#signals
func _on_level_1_body_entered(body: Node2D) -> void:
	if body == %chickenMapPiece:
		$foreground/level1/outline.visible = true
		selected = 1

func _on_level_1_body_exited(body: Node2D) -> void:
	if body == %chickenMapPiece:
		$foreground/level1/outline.visible = false
		selected = 0

func _on_level_2_body_entered(body: Node2D) -> void:
	if body == %chickenMapPiece:
		$foreground/level2/outline.visible = true
		selected = 2

func _on_level_2_body_exited(body: Node2D) -> void:
	if body == %chickenMapPiece:
		$foreground/level2/outline.visible = false
		selected = 0

func _on_level_3_body_entered(body: Node2D) -> void:
	if body == %chickenMapPiece:
		$foreground/level3/outline.visible = true
		selected = 3

func _on_level_3_body_exited(body: Node2D) -> void:
	if body == %chickenMapPiece:
		$foreground/level3/outline.visible = false
		selected = 0

func _on_level_4_body_entered(body: Node2D) -> void:
	if body == %chickenMapPiece:
		$foreground/level4/outline.visible = true
		selected = 4

func _on_level_4_body_exited(body: Node2D) -> void:
	if body == %chickenMapPiece:
		$foreground/level4/outline.visible = false
		selected = 0
		
func _on_level_5_body_entered(body: Node2D) -> void:
	if body == %chickenMapPiece:
		$foreground/level5/outline.visible = true
		selected = 5

func _on_level_5_body_exited(body: Node2D) -> void:
	if body == %chickenMapPiece:
		$foreground/level5/outline.visible = false
		selected = 0


func _on_home_body_entered(body: Node2D) -> void:
	if body == %chickenMapPiece:
		%BarnIconHover.visible = true
		selected = -1


func _on_home_body_exited(body: Node2D) -> void:
	if body == %chickenMapPiece:
		%BarnIconHover.visible = false
		selected = 0
