extends Node


var obj


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true
	Global.current_state = Global.GameState.title
	Global.target = Array()
	
	obj = $Main.find_children("*Enemy*", "CharacterBody3D", true, true)
	Global.target.clear()
	for i in obj.size():
		if obj[i].targetTag == Global.targetType.enemy:
			Global.target.append(obj[i])
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.current_state == Global.GameState.game:
		if Global.player_hp <= 0:
			Global.current_state = Global.GameState.result
		var remaining = 0
		for i in Global.target.size():
			if is_instance_valid(Global.target[i]):
				remaining += 1
		$UI/HUD/Target.set_text("target: %d" % remaining)
		if remaining == 0:
			Global.current_state = Global.GameState.result


func _on_timer_timeout():
	Global.time += 0.1
	$UI/HUD/Timer.set_text("time: %08.1f" % Global.time)
