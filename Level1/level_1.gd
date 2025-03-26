extends Node2D

var avatar_file = "user://player_data.ini"

var bg_music_player = AudioStreamPlayer.new()
var bg_music = load("res://Level1/perilous-journey.mp3")
var sound_player = AudioStreamPlayer.new()
var splash = preload("res://Level1/splash.mp3")

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
	
	$Foreground/item.item_collected.connect(collect_item)
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
		
	var avatar = config_file.get_value("Player", "choice", 1)
	if avatar == 2:
		var sprite = load("res://Player/chicken2.tscn").instantiate()
		%player.remove_child(%player.get_node("chimken"))
		%player.add_child(sprite)
	if avatar == 3:
		pass
			
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
