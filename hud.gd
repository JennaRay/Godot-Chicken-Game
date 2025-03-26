extends CanvasLayer

signal pause
signal unpause

func _process(_delta: float):
	if Input.is_action_just_pressed("open_inventory"):
		open_inventory()
		
func save_hud():
	%Inventory.save_inv()

func load_hud():
	%Inventory.load_inv()

func display_window(state: bool):
	if state:
		%promptLabel.visible = true
	else:
		%promptLabel.visible = false
		
func reset_window():
	%promptLabel.text = ""
	%promptLabel.visible = false
	
func set_prompt(prompt: String):
	%promptLabel.text = prompt
	
func open_inventory():
	%Inventory.open_inv()
	if %Inventory.open:
		%Inventory.visible = false
		%Inventory.open = false
	else:
		%Inventory.visible = true
		%Inventory.open = true
		
func game_over():
	%gameOver.visible = true
	
func settings():
	if %settings.visible:
		%settings.visible = false
		unpause.emit()
	else:
		%settings.visible = true
		pause.emit()
	
func _on_texture_button_pressed() -> void:
	settings()

func _on_bg_music_button_toggled(toggled_on: bool) -> void:
	if %bgMusicButton.button_pressed:
		print("on")
	else:
		print("off")

func _on_sfx_button_toggled(toggled_on: bool) -> void:
	if %sfxButton.button_pressed:
		print("on")
	else:
		print("off")

func _on_button_pressed() -> void:
	get_tree().quit()
