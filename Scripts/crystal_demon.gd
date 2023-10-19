extends CharacterBody2D

@export var speed: float

var target: Node2D

var _motion: Vector2

const tile_size = 128

func _ready():
	_motion = Vector2.UP

func _physics_process(delta):
	pass

func trigger_explode():
	pass
	
func _change_motion() -> Vector2:
	if abs(target.position.x - position.x) > tile_size:
		pass
		
	return Vector2.ZERO
