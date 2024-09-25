class_name FallState
extends State


@export var actor: CharacterBody3D
@export var animation_tree: AnimationTree

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func Enter():
	animation_tree.set("parameters/Movement/blend_amount", -0.5)


func Exit():
	actor.velocity = Vector3.ZERO


func Physics_update(_delta):
	actor.velocity.y -= gravity * _delta
	if actor.is_on_floor():
		transitioned.emit("IdleState")


func _input(event):
	if event is InputEventMouseButton and event.is_pressed() and event.get_button_index() == MOUSE_BUTTON_LEFT and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		transitioned.emit("ShootState")
