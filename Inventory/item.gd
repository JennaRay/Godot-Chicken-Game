extends Node2D

var image_path = "res://Inventory/donut.png"
var name_string = "donut"

func set_variables(p, n):
	image_path = p
	name_string = n
	name = n
	
	$Sprite2D.set_texture(load(image_path))

func collect():
	queue_free()


func _on_interact_box_body_entered(body: Node2D) -> void:
	if not %Inventory.slots_full():
		%Inventory.add(self)
		queue_free()
