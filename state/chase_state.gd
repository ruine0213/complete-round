class_name ChaseState
extends State


@export var actor: CharacterBody3D
@export var animation_tree: AnimationTree


func Enter():
	animation_tree.set("parameters/Movement/blend_amount", 1)
	actor.navigation_agent.set_target_position(actor.target.get_global_position())
	$Timer.start()

func Exit():
	actor.navigation_agent.set_velocity(Vector3.ZERO)
	actor.velocity = Vector3.ZERO
	actor.navigation_agent.set_target_position(actor.get_global_position())
	$Timer.stop()


func Physics_update(_delta):
	
	if not actor.get_node("Vision").overlaps_body(actor.target):
		actor.look_at(actor.target.get_global_position())
		actor.Rotation_clamp()
		transitioned.emit("EnemyIdleState")
	
	if actor.get_node("RayCast").get_collider() == actor.target:
		transitioned.emit("EngageState")
	
	
	var new_transform = actor.transform.looking_at(actor.target.get_global_position(), Vector3.UP)
	actor.transform = actor.transform.interpolate_with(new_transform, actor.speed * _delta)
	actor.Rotation_clamp()
	
	


func _on_timer_timeout() -> void:
	actor.navigation_agent.set_target_position(actor.target.get_global_position())
