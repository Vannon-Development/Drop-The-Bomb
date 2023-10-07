extends Node

enum selection {start, upgrade}

@export var start_icon: Node2D
@export var upgrade_icon: Node2D

var _start: bool = false
var _selection: selection = selection.start
var _delay: int

func _ready():
	Data.load_data()
	_delay = Time.get_ticks_msec() + 500

func _process(_delta):
	if Input.is_action_just_pressed("Game Start") && !_start && Time.get_ticks_msec() > _delay:
		if _selection == selection.start: _start_game()
		elif _selection == selection.upgrade: _upgrade()
	
	if Input.is_action_just_pressed("Up"):
		if _selection == selection.upgrade:
			upgrade_icon.visible = false
			start_icon.visible = true
			_selection = selection.start
	
	if Input.is_action_just_pressed("Down"):
		if _selection == selection.start:
			upgrade_icon.visible = true
			start_icon.visible = false
			_selection = selection.upgrade

func _start_game():
	var game = load("res://Objects/game_level.tscn")
	var obj = game.instantiate()
	get_parent().add_child(obj)
	_start = true
	GameControl.start_game()
	queue_free()

func _upgrade():
	var upgrade = load("res://Objects/upgrade_screen.tscn")
	var obj = upgrade.instantiate()
	get_parent().add_child(obj)
	_start = true
	queue_free()
