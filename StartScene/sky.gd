extends CanvasLayer



func _on_sky_box_body_exited(body: Node2D) -> void: #this isn't working
	if body.has_method("free_cloud"):
		body.free_cloud()
		%sky.remove_child(body)
		print("cloud")
