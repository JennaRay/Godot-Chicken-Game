extends Node2D



func _on_interact_box_body_entered(_body: Node2D) -> void:
		queue_free()
