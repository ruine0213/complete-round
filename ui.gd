extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var is_pause_just_pressed: bool = Input.is_action_just_pressed("ui_cancel")
	
	if is_pause_just_pressed:
		if Global.current_state == Global.GameState.game:
			Global.current_state = Global.GameState.pause
		elif Global.current_state == Global.GameState.pause:
			Global.current_state = Global.GameState.game


func _on_start_pressed():
	Global.current_state = Global.GameState.game


func _on_return_pressed():
	Global.current_state = Global.GameState.title
	get_tree().reload_current_scene()
