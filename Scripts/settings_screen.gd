extends menu_select

@export var back_marker: Sprite2D
@export var erase_marker: Sprite2D

enum selection { back, erase }

func _ready():
	selection_cursors = [back_marker, erase_marker]
	actions = [_select_back, _select_erase]
	super._ready()

func _process(delta):
	if Input.is_action_just_pressed("Pause"):
		_select_back()
	super._process(delta)

func _select_back():
	var screen: Node2D = load("res://Objects/start_screen.tscn").instantiate()
	add_sibling(screen)
	queue_free()

func _select_erase():
	Data.full_clear()
