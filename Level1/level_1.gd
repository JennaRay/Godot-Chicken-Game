extends Node2D

var avatar_file = "user://player_data.ini"
var map_file = "user://game_data.ini"

var bg_music_player = AudioStreamPlayer.new()
var bg_music = load("res://Level1/pond-song.mp3")
var sound_player = AudioStreamPlayer.new()
var splash = preload("res://Level1/splash.mp3")

var completed = false

func _ready():
	load_level()
	bg_music_player.stream = bg_music
	add_child(bg_music_player)
	bg_music_player.play()
	add_child(sound_player)
	
	
	%HUD.reset_window()
	#connect signals
	$Foreground/antagonist.gameOver.connect(game_over)
	$Foreground/antagonist2.gameOver.connect(game_over)
	$Foreground/antagonist3.gameOver.connect(game_over)
	$Foreground/antagonist4.gameOver.connect(game_over)
	$Foreground/antagonist5.gameOver.connect(game_over)
	$Foreground/antagonist6.gameOver.connect(game_over)
	%player.health_depleted.connect(leave)
	%player.lost_life.connect(%HUD.lose_life)

	if not completed:
		$"Foreground/Glider Wing (right)".item_collected.connect(collect_item)
		$"Foreground/Glider Wing (right)".image_path = "res://Glider/glider-right-wing.png"
		$"Foreground/Glider Wing (right)".name_string = "Glider Wing (right)"
	%HUD.get_node("Inventory").item_dropped.connect(drop_item)

func _process(_delta: float) -> void:
	if %water.overlaps_body(%player):
		game_over()
	
	if %player.dead:
		if Input.is_action_just_pressed("enter"):
			restart()
		if Input.is_action_just_pressed("shift"):
			leave()
			
func load_level():
	var config_file := ConfigFile.new()
	var error := config_file.load(avatar_file)
		
	if error:
		print("An error happened while loading data for main: ", error)
		return
		
	#%player.health = config_file.get_value("Player", "lives", 3)
	#%HUD.set_lives(%player.health)
	var avatar = config_file.get_value("Player", "choice", 1)
	if avatar == 2:
		var sprite = load("res://Player/chicken2.tscn").instantiate()
		%player.remove_child(%player.get_node("chimken"))
		%player.add_child(sprite)
	if avatar == 3:
		var sprite = load("res://Player/chicken3.tscn").instantiate()
		%player.remove_child(%player.get_node("chimken"))
		%player.add_child(sprite)
	
	error = 0
	error = config_file.load(map_file)
	if config_file.get_value("Map", "pond", 0) == 1:
		completed = true
		$Foreground.remove_child($Foreground.get_node("Glider Wing (right)"))
		
func save_level():
	%HUD.save_hud()
	var config_file := ConfigFile.new()
	var error := config_file.load(map_file)
	if error:
		print("error while loading save file on level one ", error)
	config_file.set_value("Map", "pond", 1)
	var save_error := config_file.save(map_file)
	if save_error:
		print("error while saving file level 1, ", save_error)
	#config_file.load(avatar_file)
	#config_file.set_value("Player", "lives", %player.health)
	#config_file.save(avatar_file)

func drop_item(path: String):
	var item = preload("res://Inventory/item.tscn").instantiate()
	item.image_path = path
	item.item_collected.connect(collect_item)
	var image = load(path)
	var sprite = Sprite2D.new()
	sprite.set_texture(image)
	item.add_child(sprite)
	item.position.x = %player.position.x - 130
	item.position.y = %player.position.y - 20
	$Foreground.add_child(item)
		
func collect_item(item: Object):
	%HUD.get_node("Inventory").add(item)
	save_level()
	%HUD.win_game()
	await get_tree().create_timer(1.0).timeout
	leave()

func game_over():
	%HUD.game_over()
	%player.rotation = 3
	%player.dead = true
	
func restart():
	%player.dead = false
	get_tree().change_scene_to_file("res://Level1/level_1.tscn")
	
func leave():
	get_tree().change_scene_to_file("res://Map/map.tscn")

func _on_water_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		sound_player.stream = splash
		sound_player.play()
		body.take_damage()
