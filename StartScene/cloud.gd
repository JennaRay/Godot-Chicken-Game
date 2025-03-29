extends Area2D

var speed = 1

func _physics_process(_delta: float) -> void:
	var direction = Vector2.RIGHT
	position += direction * speed
	
	
func free_cloud():
	print("cloud deleted")
	queue_free()
	#this doesn't work
