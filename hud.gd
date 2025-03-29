extends CanvasLayer

var sound_player = AudioStreamPlayer.new()
var success_sound = load("res://HUD/success.wav")

signal pause
signal unpause

var lives = 3

func _ready():
	add_child(sound_player)

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
	
func win_game():
	sound_player.stream = success_sound
	sound_player.play()
	$success.visible = true

func settings():
	if %settings.visible:
		%settings.visible = false
		unpause.emit()
	else:
		%settings.visible = true
		pause.emit()
		
func lose_life():
	lives -= 1
	if lives == 2:
		$Heart3.visible = false
	if lives == 1:
		$Heart2.visible = false
	if lives <= 0:
		$Heart.visible = false
	
func set_lives(lives: int):
	if lives <= 2:
		$Heart3.visible == false
	if lives == 1:
		$Heart2.visible == false 

func _on_texture_button_pressed() -> void:
	settings()

func _on_bg_music_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		print("on")
	else:
		print("off")

func _on_sfx_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		print("on")
	else:
		print("off")

func _on_button_pressed() -> void:
	get_tree().quit()
