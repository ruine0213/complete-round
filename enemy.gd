extends game_Object

# --------credit--------
# stair_step_up and stair_step_down method are originally released under the MIT license.
# Copyright (c) 2024 JKWall


@export var target: CharacterBody3D
@export var speed: float = 1.0

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

@onready var raycast = $RayCast

@onready var healthbar3d = $HealthBar3D
@onready var healthbar2d = $HealthBar3D/SubViewport/HealthBar2D


var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


const MAX_STEP_HEIGHT: float = 0.5

var direction: Vector3

var is_grounded
var was_grounded


func _ready():
	is_grounded = true
	was_grounded = true
	direction = Vector3.ZERO
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))
	healthbar3d.texture = $HealthBar3D/SubViewport.get_texture()
	healthbar2d.max_value = durability
	call_deferred("actor_setup")

func actor_setup():
	await get_tree().physics_frame
	navigation_agent.set_target_position(global_position)

func update_health(value):
	healthbar2d.value = value

func damage(i):
	super(i)
	update_health(durability)
	look_at(target.get_global_position())
	var rot = rotation_degrees
	rot.x = clamp(rotation.x, 0, 0)
	rotation_degrees = rot

func Rotation_clamp():
	var rot = rotation_degrees
	rot.x = clamp(rotation.x, 0, 0)
	rotation_degrees = rot


func stair_step_down():
	if is_grounded:
		return

	if velocity.y <= 0 and was_grounded:
		var body_test_result = PhysicsTestMotionResult3D.new()
		var body_test_params = PhysicsTestMotionParameters3D.new()
		
		body_test_params.from = self.global_transform
		body_test_params.motion = Vector3(0, -MAX_STEP_HEIGHT, 0)
		
		if PhysicsServer3D.body_test_motion(self.get_rid(), body_test_params, body_test_result):
			position.y += body_test_result.get_travel().y
			apply_floor_snap()
			is_grounded = true

func stair_step_up(dir):
	if dir == Vector3.ZERO:
		return
	
	var body_test_params = PhysicsTestMotionParameters3D.new()
	var body_test_result = PhysicsTestMotionResult3D.new()
	
	var test_transform = global_transform
	var distance = dir * 0.1
	body_test_params.from = self.global_transform
	body_test_params.motion = distance
	
	if !PhysicsServer3D.body_test_motion(self.get_rid(), body_test_params, body_test_result):
		return
	
	var remainder = body_test_result.get_remainder()
	test_transform = test_transform.translated(body_test_result.get_travel())
	
	var step_up = MAX_STEP_HEIGHT * Vector3.UP
	body_test_params.from = test_transform
	body_test_params.motion = step_up
	PhysicsServer3D.body_test_motion(self.get_rid(), body_test_params, body_test_result)
	test_transform = test_transform.translated(body_test_result.get_travel())
	
	body_test_params.from = test_transform
	body_test_params.motion = remainder
	PhysicsServer3D.body_test_motion(self.get_rid(), body_test_params, body_test_result)
	test_transform = test_transform.translated(body_test_result.get_travel())
	
	body_test_params.from = test_transform
	body_test_params.motion = MAX_STEP_HEIGHT * -Vector3.UP
	
	if !PhysicsServer3D.body_test_motion(self.get_rid(), body_test_params, body_test_result):
		return
	
	test_transform = test_transform.translated(body_test_result.get_travel())
	
	var global_pos = global_position
	velocity.y = 0
	global_pos.y = test_transform.origin.y
	global_position = global_pos



func _physics_process(delta):
	
	was_grounded = is_grounded
	if is_on_floor():
		is_grounded = true
	else:
		is_grounded = false
		velocity.y -= gravity * delta
	
	if navigation_agent.is_navigation_finished():
		return
	var new_velocity: Vector3
	
	var current_position: Vector3 = global_position
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()
	direction = current_position.direction_to(next_path_position).normalized()
	new_velocity = direction * speed
	
	navigation_agent.set_velocity(new_velocity)
	
	


func _on_velocity_computed(safe_velocity: Vector3):
	velocity.x = safe_velocity.x
	velocity.z = safe_velocity.z
	
	stair_step_up(direction)
	move_and_slide()
	stair_step_down()
