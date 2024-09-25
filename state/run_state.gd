class_name RunState
extends State


@export var actor: CharacterBody3D
@export var animation_tree: AnimationTree

@export var speed: float = 5.0


func Enter():
	animation_tree.set("parameters/Movement/blend_amount", 1)


func Physics_update(_delta):
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (actor.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var is_jump_just_pressed: bool = Input.is_action_just_pressed("jump")
	
	if not actor.is_on_floor():
		transitioned.emit("FallState")
	
	if is_jump_just_pressed and actor.is_on_floor():
		transitioned.emit("JumpState")
	
	
	if direction:
		actor.velocity.x = direction.x * speed
		actor.velocity.z = direction.z * speed
	else:
		actor.velocity.x = move_toward(actor.velocity.x, 0, speed)
		actor.velocity.z = move_toward(actor.velocity.z, 0, speed)
	
	if actor.velocity.x == 0 and actor.velocity.z == 0:
		transitioned.emit("IdleState")


func _input(event):
	if event is InputEventMouseButton and event.is_pressed() and event.get_button_index() == MOUSE_BUTTON_LEFT and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		transitioned.emit("ShootState")
