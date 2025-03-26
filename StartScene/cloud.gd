extends Area2D


func _physics_process(_delta: float) -> void:
	var direction = Vector2.RIGHT
	position += direction
	
	
func free_cloud():
	print("cloud deleted")
	queue_free()
	#this doesn't work
