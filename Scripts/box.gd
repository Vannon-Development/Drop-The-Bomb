extends StaticBody2D

signal door_exposed(pos: Vector2)
signal box_destroyed(box: Node2D)

@export var explode_visual: AnimatedSprite2D
@export var visual: Sprite2D
@export var crystal_template: PackedScene

var has_door: bool

var _exploding: bool

func _ready():
	_exploding = false
	GameControl.on_pause.connect(_on_pause)
	GameControl.on_resume.connect(_on_resume)
	
func trigger_explode():
	if _exploding: return
	_exploding = true
	visual.visible = false
	explode_visual.visible = true
	explode_visual.play()
	explode_visual.animation_finished.connect(_done)
	
func _done():
	if has_door:
		door_exposed.emit(position)
	elif randf() < 0.25:
		var crystal = crystal_template.instantiate()
		crystal.position = position
		crystal.quantity = 1
		get_parent().add_child(crystal)
	box_destroyed.emit(self)
	queue_free()

func _on_pause():
	if _exploding:
		explode_visual.pause()

func _on_resume():
	if _exploding:
		explode_visual.play()
