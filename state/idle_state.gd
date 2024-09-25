class_name IdleState
extends State


@export var actor: CharacterBody3D
@export var animation_tree: AnimationTree


func Enter():
	animation_tree.set("parameters/Movement/blend_amount", 0)


func Physics_update(_delta):
	var is_jump_just_pressed: bool = Input.is_action_just_pressed("jump")
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	
	if is_jump_just_pressed and actor.is_on_floor():
		transitioned.emit("JumpState")
	
	if not actor.is_on_floor():
		transitioned.emit("FallState")
		
	if input_dir:
		transitioned.emit("RunState")
	


func _input(event):
	if event is InputEventMouseButton and event.is_pressed() and event.get_button_index() == MOUSE_BUTTON_LEFT and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		transitioned.emit("ShootState")
