class_name EngageState
extends State


@export var actor: CharacterBody3D
@export var animation_tree: AnimationTree


func Enter():
	animation_tree.set("parameters/Movement/blend_amount", 0)
	$Timer.set_wait_time(randf_range(4, 8))
	$Timer.start()

func Exit():
	animation_tree.set("parameters/Movement/blend_amount", 0)
	$Timer.stop()


func Physics_update(_delta):
		
	if not actor.get_node("RayCast").get_collider() == actor.target:
		transitioned.emit("ChaseState")
	
	
	actor.look_at(actor.target.get_global_position())
	actor.Rotation_clamp()
	var rot = actor.rotation_degrees
	rot.x = clamp(actor.rotation.x, 0, 0)
	actor.rotation_degrees = rot
	
	
func _on_timer_timeout():
	transitioned.emit("ShootState")
