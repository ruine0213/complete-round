class_name InGameState
extends State


@export var ui:Node2D


func Enter():
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func Exit():
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	

func Update(delta):
	if Global.current_state == Global.GameState.pause:
		transitioned.emit("PauseState")
	elif Global.current_state == Global.GameState.result:
		transitioned.emit("ResultState")
	
	
	
	
