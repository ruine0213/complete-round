class_name TitleState
extends State


@export var ui:Node2D

@export var timer:Timer


func Enter():
	ui.get_node("Title").show()
	Global.score = 0
	Global.time = 0
	ui.get_node("HUD").hide()
	

func Exit():
	ui.get_node("Title").hide()
	ui.get_node("Ready/ReadyGo").set_text("Ready?")
	ui.get_node("Ready/ReadyGo").set_visible_ratio(0.0)
	ui.get_node("Ready").show()
	var duration:float = 0.05
	
	while ui.get_node("Ready/ReadyGo").get_visible_ratio() < 1:
		ui.get_node("Ready/ReadyGo").set_visible_ratio(ui.get_node("Ready/ReadyGo").get_visible_ratio() + (1.0 / ui.get_node("Ready/ReadyGo").get_text().length()))
		await get_tree().create_timer(duration).timeout
	await get_tree().create_timer(2.0).timeout
	ui.get_node("Ready/ReadyGo").set_text("Go!")
	timer.start()
	get_tree().paused = false
	
	ui.get_node("HUD").show()
	await get_tree().create_timer(1.0).timeout
	ui.get_node("Ready").hide()


func Update(delta):
	if Global.current_state == Global.GameState.game:
		transitioned.emit("InGameState")
