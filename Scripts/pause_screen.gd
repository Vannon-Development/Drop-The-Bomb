extends menu_select

signal quit(screen: Node2D)

@export var resume_marker: Sprite2D
@export var quit_marker: Sprite2D

enum selection { resume, quit }

func _ready():
	selection_cursors = [resume_marker, quit_marker]
	actions = [_dismiss, _quit_game]
	GameControl.pause()
	super._ready()

func _process(delta):
	if Input.is_action_just_pressed("Pause"):
		_dismiss()
	super._process(delta)

func _dismiss():
	GameControl.resume()
	queue_free()
	
func _quit_game():
	quit.emit(self)
