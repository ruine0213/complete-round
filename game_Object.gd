extends CharacterBody3D
class_name game_Object

@export var targetTag:Global.targetType
@export var durability:int
@export var immortality:bool
@export var death_sound:AudioStreamPlayer3D

signal destroy(target, audio)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func damage(i):
	if !immortality && durability >= i:
		durability = durability - i
	if !immortality && durability <= 0:
		destroy.emit(self, death_sound)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _physics_process(delta):
	pass
