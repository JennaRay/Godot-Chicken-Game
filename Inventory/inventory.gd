extends Node2D

var slots = [["slot1", 0, null],["slot2", 0, null],["slot3", 0, null],["slot4", 0, null],["slot5", 0, null],["slot6", 0, null]]

var open = false

func slots_full():
	for slot in slots:
		if slot[1] != 1:
			return false
	return true

func add(item: Object):
	for i in range(0, len(slots)):
		if slots[i][1] == 0:
			slots[i][1] = 1
			slots[i][2] = item
			set_item(i)
			print("item added to slot ", i)
			break
			
	
func remove(slot: int):
	if slot == 0:
		$slot1.remove_child($slot1.get_child(len($slot1.get_children())))
	elif slot == 1:
		$slot2.remove_child($slot2.get_child(len($slot2.get_children())))
	elif slot == 2:
		$slot3.remove_child($slot3.get_child(len($slot3.get_children())))
	elif slot == 3:
		$slot4.remove_child($slot4.get_child(len($slot4.get_children())))
	elif slot == 4:
		$slot5.remove_child($slot5.get_child(len($slot5.get_children())))
	elif slot == 5:
		$slot5.remove_child($slot5.get_child(len($slot5.get_children())))
	else:
		print("remove: slot out of range")
		
	if slot in range(0, len(slots)):
		slots[slot][1] = 0
		slots[slot][2] = null

	
func set_item(slot: int):
	var path = slots[slot][2].image_path
	var image = load(path)
	var name = slots[slot][2].name
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


func _on_slot_1_mouse_entered() -> void:
	print("donut hover")
	if Input.is_action_just_pressed("click"):
		remove(0)
		print("donut clicked")
		if %Game:
			pass
	
