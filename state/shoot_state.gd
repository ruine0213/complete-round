class_name ShootState
extends State


signal shoot(bullet, target, shooter)

@export var actor: CharacterBody3D
@export var animation_tree: AnimationTree
@export var shoot_audio: AudioStreamPlayer3D

var Bullet = preload("res://bullet.tscn")


func _ready():
	animation_tree.animation_finished.connect(_on_animation_tree_animation_finished)


func Enter():
	actor.velocity = Vector3.ZERO
	animation_tree.set("parameters/OneShot/request",AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	await get_tree().create_timer(0.1).timeout
	var target_point
	if actor.find_child("RayCast"):
		target_point = actor.raycast.get_collision_point()
	else:
		target_point = actor.target.get_global_position()
	shoot.emit(Bullet, target_point, actor)
	shoot_audio.play()

func Physics_update(_delta):
	pass


func _on_animation_tree_animation_finished(anim_name):
	if anim_name == "Shoot":
		if actor.targetTag == Global.targetType.enemy:
			transitioned.emit("EngageState")
		else:
			transitioned.emit("IdleState")
