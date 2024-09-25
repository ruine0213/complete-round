extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.player = $Player
	var shooters = find_children("ShootState")
	for i in shooters.size():
		shooters[i].shoot.connect(Callable(_on_shoot_state_shoot))
	for i in get_child_count():
		if get_child(i) is game_Object:
			get_child(i).destroy.connect(Callable(_on_game_object_destroy))
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func shoot(bullet, target, shooter):
	var b = bullet.instantiate()
	add_child(b)
	
	b.set_global_position(get_node(shooter.name + "/CollisionShape3D/Character/RootNode/Root/Skeleton3D/BoneAttachment3D/Weapon/blasterA").get_global_position())
	b.set_shooter(shooter)
	b.set_target(target)


func _on_shoot_state_shoot(bullet, target, shooter):
	shoot(bullet, target, shooter)


func _on_game_object_destroy(target, audio):
	audio.play()
	target.get_node("ExplodeParticles").set_emitting(true)
	await get_tree().create_timer(2.0).timeout
	if target.targetTag == Global.targetType.enemy:
		target.queue_free()
