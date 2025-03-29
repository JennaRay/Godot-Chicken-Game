extends Node2D

var save_file = "user://player_data.ini"

var slots = [["slot1", 0, null],["slot2", 0, null],["slot3", 0, null],["slot4", 0, null],["slot5", 0, null],["slot6", 0, null]]
var slots_save = {1: {"image_path": "", "name": ""},2: {"image_path": "", "name": ""},3: {"image_path": "", "name": ""},4: {"image_path": "", "name": ""},5: {"image_path": "", "name": ""},6: {"image_path": "", "name": ""}}

var open = false
var slotColor = Color(0.67, 0.57, 0.42)
var slotHover = Color(0.7,0.5,0.3)

var selected = 0

var sound_player = AudioStreamPlayer.new()
var open_sound = preload("res://Inventory/open_inventory.wav")
var drop_sound = preload("res://Inventory/pop.ogg")
var pickup_sound = preload("res://Inventory/pickup.mp3")

signal item_dropped(image_path)

func _ready():
	load_inv()
	add_child(sound_player)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("click"):
		if (visible == true) and (selected != 0) and (slots[selected -1][1] != 0):
			drop_item()
			remove(selected -1)

func load_inv():
	var config_file := ConfigFile.new()
	var error := config_file.load(save_file)
		
	if error:
		print("An error happened while loading data: ", error)
		return
	slots_save[1] = config_file.get_value("Inventory", "slot1", {"image_path" : "", "name": ""})
	slots_save[2] = config_file.get_value("Inventory", "slot2", {"image_path" : "", "name": ""})
	slots_save[3] = config_file.get_value("Inventory", "slot3", {"image_path" : "", "name": ""})
	slots_save[4] = config_file.get_value("Inventory", "slot4", {"image_path" : "", "name": ""})
	slots_save[5] = config_file.get_value("Inventory", "slot5", {"image_path" : "", "name": ""})
	slots_save[6] = config_file.get_value("Inventory", "slot6", {"image_path" : "", "name": ""})
	
	load_slots()
	
func load_slots():
	for i in range(0, len(slots)):
		if slots_save[i+1]["image_path"] != "":
			var itemDict = {"name_string": slots_save[i+1]["name"], "image_path": slots_save[i+1]["image_path"]}
			slots[i][1] = 1
			slots[i][2] = itemDict
			set_item(i)
			

func save_inv():
	var config_file := ConfigFile.new()
	var error := config_file.load(save_file)
	if error:
		print("An error happened while saving data: ", error)
		
	config_file.set_value("Inventory", "slot1", slots_save[1])
	config_file.set_value("Inventory", "slot2", slots_save[2])
	config_file.set_value("Inventory", "slot3", slots_save[3])
	config_file.set_value("Inventory", "slot4", slots_save[4])
	config_file.set_value("Inventory", "slot5", slots_save[5])
	config_file.set_value("Inventory", "slot6", slots_save[6])
	
	var save_error := config_file.save(save_file)
	if save_error:
		print("An error happened while saving data: ", save_error)
	else:
		print("inv saved")

func open_inv():
	sound_player.stream = open_sound
	sound_player.play()
		
		
func slots_full():
	for slot in slots:
		if slot[1] != 1:
			return false
	return true

func add(item: Object):
	for i in range(0, len(slots)):
		if slots[i][1] == 0:
			#create dict of all item details
			var itemDict = {"name_string": item.name, "image_path": item.image_path}
			slots_save[i+1]["image_path"] = item.image_path
			slots_save[i+1]["name"] = item.name
			slots[i][1] = 1
			slots[i][2] = itemDict
			set_item(i)
			
			sound_player.stream = pickup_sound
			sound_player.play()
			
			print("item added to slot ", i)
			break
			
	
func remove(slot: int):
	if slot == 0:
		$slot1.remove_child($slot1.get_child(2))
	elif slot == 1:
		$slot2.remove_child($slot2.get_child(2))
	elif slot == 2:
		$slot3.remove_child($slot3.get_child(2))
	elif slot == 3:
		$slot4.remove_child($slot4.get_child(2))
	elif slot == 4:
		$slot5.remove_child($slot5.get_child(2))
	elif slot == 5:
		$slot5.remove_child($slot5.get_child(2))
	else:
		print("remove: slot out of range")
		
	if slot in range(0, len(slots)):
		slots[slot][1] = 0
		slots[slot][2] = null
		slots_save[slot+1] = {"image_path": "", "name": ""}

	
func set_item(slot: int):
	var path = slots[slot][2]["image_path"]
	var image = load(path)
	var item = Sprite2D.new()
	item.set_texture(image)
	if slot == 0:
		$slot1.add_child(item)
	elif slot == 1:
		$slot2.add_child(item)
	elif slot == 2:
		$slot3.add_child(item)
	elif slot == 3:
		$slot4.add_child(item)
	elif slot == 4:
		$slot5.add_child(item)
	elif slot == 5: 
		$slot6.add_child(item)
	else:
		print("set_slot: slot out of range")

func drop_item():
	sound_player.stream = drop_sound
	sound_player.play()
	
	var item = slots[selected -1][2]
	var path = item["image_path"]
	
	item_dropped.emit(path)

#Label setters
func display_info(item : Dictionary):
	$Label.text = item.name_string
	
func display_message(text : String):
	$Label.text = text
	
func clear_display():
	$Label.text = "..."
	
	
#Signals	
func _on_slot_1_mouse_entered() -> void:
	$slot1/ColorRect.color = slotHover
	selected = 1
	
	if slots[0][2]:
		display_info(slots[0][2])
	else:
		display_message("empty slot")
	

func _on_slot_1_mouse_exited() -> void:
	$slot1/ColorRect.color = slotColor
	clear_display()
	selected = 0

func _on_slot_2_mouse_entered() -> void:
	$slot2/ColorRect.color = slotHover
	selected = 2
	
	if slots[1][2]:
		display_info(slots[1][2])
	else:
		display_message("empty slot")
		
func _on_slot_2_mouse_exited() -> void:
	$slot2/ColorRect.color = slotColor
	clear_display()
	selected = 0

func _on_slot_3_mouse_entered() -> void:
	$slot3/ColorRect.color = slotHover
	selected = 3
	
	if slots[2][2]:
		display_info(slots[2][2])
	else:
		display_message("empty slot")
		
func _on_slot_3_mouse_exited() -> void:
	$slot3/ColorRect.color = slotColor
	clear_display()
	selected = 0

func _on_slot_4_mouse_entered() -> void:
	$slot4/ColorRect.color = slotHover
	selected = 4
	if slots[3][2]:
		display_info(slots[3][2])
	else:
		display_message("empty slot")

func _on_slot_4_mouse_exited() -> void:
	$slot4/ColorRect.color = slotColor
	clear_display()
	selected = 0

func _on_slot_5_mouse_entered() -> void:
	$slot5/ColorRect.color = slotHover
	selected = 5
	if slots[4][2]:
		display_info(slots[4][2])
	else:
		display_message("empty slot")
		
func _on_slot_5_mouse_exited() -> void:
	$slot5/ColorRect.color = slotColor
	clear_display()
	selected = 0

func _on_slot_6_mouse_entered() -> void:
	$slot6/ColorRect.color = slotHover
	selected = 6
	if slots[5][2]:
		display_info(slots[5][2])
	else:
		display_message("empty slot")
		
func _on_slot_6_mouse_exited() -> void:
	$slot6/ColorRect.color = slotColor
	clear_display()
	selected = 0
