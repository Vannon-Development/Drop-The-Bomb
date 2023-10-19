extends Node2D

@export var label: Label
@export var timer: float

var camera

var _time

func set_level(level: int):
	label.text = "Level " + str(level)
	
func _ready():
	_time = Time.get_ticks_msec() + timer * 1000

func _process(_delta):
	if Time.get_ticks_msec() >= _time: queue_free()
	position = camera.get_screen_center_position() - camera.get_viewport_rect().size / 2

