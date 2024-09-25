class_name ResultState
extends State


@export var ui:Node2D


func Enter():
	ui.get_node("Result").show()
	ui.get_node("Pause").show()
	if Global.player_hp > 0:
		ui.get_node("Result/Message").set_text("Round Completed!")
	else:
		ui.get_node("Result/Message").set_text("DEFEAT!")
	var down = 0.001
	for i in Global.target.size():
		if !is_instance_valid(Global.target[i]):
			down += 1
	Global.score = (down + Global.player_hp)*10000 / Global.time
	ui.get_node("Result/Score").set_text("score: %d" % Global.score)


func Exit():
	ui.get_node("Result").hide()
	ui.get_node("Pause").hide()


func Update(delta):
	if Global.current_state == Global.GameState.title:
		transitioned.emit("TitleState")
