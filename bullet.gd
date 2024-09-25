extends CharacterBody3D


var SPEED = 24.0
var target_point
var shooter


# Called when the node enters the scene tree for the first time.
func _ready():
	target_point = Vector3.ZERO

func set_shooter(obj):
	shooter = obj

func set_target(point):
	target_point = point
	transform = transform.looking_at(target_point)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	var collision_info
	
	translate(Vector3(0,0,-SPEED * delta))
	collision_info = move_and_collide(velocity * delta)
	if collision_info and collision_info.get_collider() != shooter:
		if collision_info.get_collider() is game_Object:
			collision_info.get_collider().damage(1)
		queue_free()
	
	
