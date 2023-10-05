extends Node

@export var label: Label
@export var timer: float

var _time

func set_level(level: int):
	label.text = "Level " + str(level)
	
func _ready():
	_time = Time.get_ticks_msec() + timer * 1000

func _process(_delta):
	if Time.get_ticks_msec() >= _time: queue_free()
