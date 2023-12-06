extends menu_select

enum selection {start, upgrade, options}

@export var start_icon: Sprite2D
@export var upgrade_icon: Sprite2D
@export var options_icon: Sprite2D

var _delay: int

func _ready():
	Data.load_data()
	selection_cursors = [start_icon, upgrade_icon, options_icon]
	actions = [_start_game, _upgrade, _options]
	_delay = Time.get_ticks_msec() + 100
	super._ready()

func _process(delta):
	if Time.get_ticks_msec() < _delay: return
	super._process(delta)

func _start_game():
	var obj: Node2D = load("res://Objects/game_level.tscn").instantiate()
	add_sibling(obj)
	GameControl.start_game()
	queue_free()

func _upgrade():
	var obj = load("res://Objects/upgrade_screen.tscn").instantiate()
	add_sibling(obj)
	queue_free()

func _options():
	var options: Node2D = load("res://Objects/settings_screen.tscn").instantiate()
	add_sibling(options)
	queue_free()
