extends StaticBody2D

var slots = [0,0,0,0]
var slots_save = ["", "", "", ""]

var sound_player = AudioStreamPlayer.new()
var thump = preload("res://Barn/thump.wav")

var save_file = "user://game_data.ini"

func _ready():
	add_child(sound_player)

func save_slots():
	var config_file := ConfigFile.new()
	var error = config_file.load(save_file)
	if error:
		print("error while saving workbench ", error)
		return
	config_file.set_value("Workbench", "slot1", slots_save[0])
	config_file.set_value("Workbench", "slot2", slots_save[1])
	config_file.set_value("Workbench", "slot3", slots_save[2])
	config_file.set_value("Workbench", "slot4", slots_save[3])
	
	var save_error := config_file.save(save_file)
	if save_error:
		print("error while saving workbench ", save_error)

func load_slots():
	var config_file := ConfigFile.new()
	var error = config_file.load(save_file)
	if error:
		print("error while loading workbench ", error)
		return
	
	slots_save[0] = config_file.get_value("Workbench", "slot1", "")
	slots_save[1] = config_file.get_value("Workbench", "slot2", "")
	slots_save[2] = config_file.get_value("Workbench", "slot3", "")
	slots_save[3] = config_file.get_value("Workbench", "slot4", "")
	
	for i in range(0, len(slots_save)):
		if slots_save[i] != "":
			set_slot(slots_save[i], i)

func add_item(image_path: String):
	sound_player.stream = thump
	sound_player.play()
	for i in range(0, len(slots)):
		if slots[i] == 0:
			set_slot(image_path, i)
			print("item added to workbench slot ", i)
			break

func set_slot(image_path, i):
	var image = Image.load_from_file(image_path)
	var spriteTexture = ImageTexture.create_from_image(image)
	var sprite = Sprite2D.new()
	sprite.texture = spriteTexture
	sprite.scale = Vector2(0.5,0.5)
	slots[i] = 1
	slots_save[i] = image_path
	if i == 0:
		$slot1.add_child(sprite)
	elif i == 1:
		$slot2.add_child(sprite)
	elif i == 2:
		$slot3.add_child(sprite)
	elif i == 3:
		$slot4.add_child(sprite)
	else:
		print("out of range")
			
func slots_full()-> bool:
	for slot in slots:
		if slot[1] == 0:
			return false
	return true
			
func slots_empty():
	for slot in slots:
		if slot[1] == 1:
			return false
	return true
