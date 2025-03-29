extends Node2D
var bg_music := AudioStreamPlayer.new()
var sound_player := AudioStreamPlayer.new()
#sound affects

var save_file = "user://player_data.ini"
var game_file = "user://game_data.ini"

#states
var tutorial_on = true
var paused = false
var prompted = false

func _ready():	
	load_main()
	#start bg music
	bg_music.stream = load("res://StartScene/farm-song.mp3")
	bg_music.autoplay = true
	add_child(bg_music)
	
	#make sure promptLabel is invisible and empty
	%HUD.reset_window()

	
	%HUD.get_node("Inventory").item_dropped.connect(drop_item)
	$Foreground/donut.item_collected.connect(collect_item)
	%HUD.pause.connect(pause)
	%HUD.unpause.connect(unpause)
	%player.lost_life.connect(%HUD.lose_life)
	if not prompted:
		$Foreground/prompt.prompt_collected.connect(play_cutscene)
	
	
func _process(_delta: float) -> void:
	#get rid of tutorial if player has moved
	if tutorial_on and (%player.velocity.x > 0 or %player.velocity.x < 0):
		%HUD.reset_window()
		tutorial_on = false
	if not paused:
		#enter if press in and in area
		if Input.is_action_just_pressed("interact"):
			if %barnWindow.overlaps_body(%player):
				%player.position = %insideWindow.global_position
				%player.scale = Vector2(.65,.65)
			elif %insideWindow.overlaps_body(%player):
				%player.position = %barnWindow.global_position
				%player.scale = Vector2(.5,.5)
			elif %exit.overlaps_body(%player):
				leave_farm()
			elif %workbench/Area2D.overlaps_body(%player):
				%HUD.set_prompt("looks like a place to make things")
				%HUD.display_window(true)

func play_cutscene():
	prompted = true
	save_main()
	await get_tree().create_timer(0.75).timeout
	get_tree().change_scene_to_file("res://StartScene/CutScene/cutscene_1.tscn")

func save_main():
	%HUD.save_hud()
	%workbench.save_slots()
	var config_file := ConfigFile.new()
	var error := config_file.load(game_file)
	if error:
		print("error while loading data for main ", error)
		return
	config_file.set_value("Map", "progress", 0)
	config_file.save(game_file)
	config_file.load(save_file)
	config_file.set_value("Player", "mainPosX", %player.position.x)
	config_file.set_value("Player", "mainPosY", %player.position.y)
	config_file.set_value("Player", "prompted", prompted)
	config_file.save(save_file)
	
func load_main():
	var config_file := ConfigFile.new()
	var error := config_file.load(save_file)
		
	if error:
		print("An error happened while loading data for main: ", error)
		return
		
	var avatar = config_file.get_value("Player", "choice", 1)
	if avatar == 2:
		var sprite = load("res://Player/chicken2.tscn").instantiate()
		%player.remove_child(%player.get_node("chimken"))
		%player.add_child(sprite)
	if avatar == 3:
		var sprite = load("res://Player/chicken3.tscn").instantiate()
		%player.remove_child(%player.get_node("chimken"))
		%player.add_child(sprite)
	
	prompted = config_file.get_value("Player", "prompted", false)
	if prompted:
		$Foreground.remove_child($Foreground.get_node("prompt"))
	
	var x = config_file.get_value("Player", "mainPosX", 0)
	var y = config_file.get_value("Player", "mainPosY", 0)
	if !(x == 0 and y == 0):
		%player.global_position.x = x
		%player.global_position.y = y
	%HUD.load_hud()
	%workbench.load_slots()

func pause():
	paused = true
	%player.pause()
	$Background/sky/cloudTimer.paused = true
	
func unpause():
	paused = false
	%player.unpause()
	$Background/sky/cloudTimer.paused = false
			
func collect_item(item: Object):
	%HUD.get_node("Inventory").add(item)
		
func drop_item(path: String):
	if %workbench/Area2D.overlaps_body(%player):
		%workbench.add_item(path)
	else:
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

			
func tutorial():
	%HUD.set_prompt("move with WASD")
	%HUD.display_window(true)
			


func spawn_cloud():
	var new_cloud = preload("res://StartScene/cloud.tscn").instantiate()
	var imageInt = randi_range(1, 3)
	var intString = str(imageInt)
	var spriteString = "res://StartScene/cloud" + intString + ".png"
	var image = load(spriteString)
	var spriteTexture = ImageTexture.create_from_image(image)
	var sprite = Sprite2D.new()
	sprite.texture = spriteTexture  
	new_cloud.add_child(sprite)  
	
	%cloudSpawner.progress_ratio = randf()
	new_cloud.global_position = %cloudSpawner.global_position
	%sky.add_child(new_cloud)

func _on_cloud_timer_timeout() -> void:
	spawn_cloud()


func _on_barn_window_area_entered(_area: Area2D) -> void:
	%HUD.set_prompt("press 'E'")
	%HUD.display_window(true)
	


func _on_barn_window_area_exited(_area: Area2D) -> void:
	%HUD.display_window(false)


func _on_exit_area_entered(_area: Area2D) -> void:
	%HUD.set_prompt("press 'E' to leave farm")
	%HUD.display_window(true)

func _on_exit_area_exited(_area: Area2D) -> void:
	%HUD.display_window(false)
	
func leave_farm():
	save_main()
	get_tree().change_scene_to_file("res://Map/map.tscn")


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == %player:
		%HUD.display_window(false)
		
