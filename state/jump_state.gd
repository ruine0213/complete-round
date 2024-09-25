class_name JumpState
extends State


@export var actor: CharacterBody3D
@export var animation_tree: AnimationTree

@export var jump_velocity: float = 4.0
@export var speed: float = 5.0

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func Enter():
	actor.velocity.y = jump_velocity
	animation_tree.set("parameters/Movement/blend_amount", -1)


func Physics_update(_delta):
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (actor.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		actor.velocity.x = direction.x * speed
		actor.velocity.z = direction.z * speed
	else:
		actor.velocity.x = move_toward(actor.velocity.x, 0, speed)
		actor.velocity.z = move_toward(actor.velocity.z, 0, speed)
	
	actor.velocity.y -= gravity * _delta
	if actor.velocity.y < 0:
		transitioned.emit("FallState")


func _input(event):
	if event is InputEventMouseButton and event.is_pressed() and event.get_button_index() == MOUSE_BUTTON_LEFT and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		transitioned.emit("ShootState")
