class_name EnemyIdleState
extends State


@export var actor: CharacterBody3D
@export var animation_tree: AnimationTree


func Enter():
	animation_tree.set("parameters/Movement/blend_amount", 0)


func Physics_update(_delta):
	
	if actor.get_node("Vision").overlaps_body(actor.target):
		transitioned.emit("ChaseState")
		
	
