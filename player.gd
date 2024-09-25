extends game_Object


var camera
var rotation_helper
var raycast

var MOUSE_SENSITIVITY = 0.2

var damage_effect


@onready var healthbar3d = $HealthBar3D
@onready var healthbar2d = $HealthBar3D/SubViewport/HealthBar2D


func _ready():
	camera = $RotationHelper/SpringArm/Camera
	rotation_helper = $RotationHelper
	raycast = $RotationHelper/SpringArm/Camera/RayCast
	raycast.add_exception(self)
	healthbar3d.texture = $HealthBar3D/SubViewport.get_texture()
	healthbar2d.max_value = durability
	damage_effect = false
	Global.player_hp = durability


func _process(delta):
	if damage_effect:
		var mat = $RotationHelper/SpringArm/Camera/RayCast/Vignette.material
		mat.set_shader_parameter("vignette_intensity", 0.4)
		await get_tree().create_timer(0.1).timeout
		mat.set_shader_parameter("vignette_intensity", 0.0)
		damage_effect = false



func _physics_process(delta):
	
	move_and_slide()



func _input(event):
	
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotation_helper.rotate_x(deg_to_rad(event.relative.y * MOUSE_SENSITIVITY * -1))
		self.rotate_y(deg_to_rad(event.relative.x * MOUSE_SENSITIVITY * -1))

		var camera_rot = rotation_helper.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -45, 60)
		rotation_helper.rotation_degrees = camera_rot
		
		

func update_health(value):
	healthbar2d.value = value

func damage(i):
	super(i)
	damage_effect = true
	Global.player_hp = durability
	update_health(durability)
