extends Node2D



func _process(delta: float) -> void:
	if Input.is_action_just_pressed("open_inventory"):
		open_inventory()
			
			
func open_inventory():
	if %Inventory.open:
		%Inventory.visible = false
		%Inventory.open = false
	else:
		%Inventory.visible = true
		%Inventory.open = true
