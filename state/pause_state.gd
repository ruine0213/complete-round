class_name PauseState
extends State


@export var ui:Node2D


func Enter():
	ui.get_node("Pause").show()
	

func Exit():
	ui.get_node("Pause").hide()


func Update(delta):
	if Global.current_state == Global.GameState.game:
		transitioned.emit("InGameState")
	elif Global.current_state == Global.GameState.title:
		transitioned.emit("TitleState")
