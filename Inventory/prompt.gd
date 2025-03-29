extends Node2D

signal prompt_collected


func _on_interact_box_body_entered(_body: Node2D) -> void:
	prompt_collected.emit()
	queue_free()
