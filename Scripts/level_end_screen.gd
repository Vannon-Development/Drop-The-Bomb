extends Node

signal dismissed

@export var level_label: Label
@export var boxes_label: Label
@export var time_label: Label

var _dismissed: bool = false

func _process(_delta):
	if !_dismissed and Input.is_action_just_pressed("Game Start"):
		_dismissed = true
		dismissed.emit()

func set_values(level: int, boxes: int, time: int):
	level_label.text = "Level " + str(level) + " Complete!"
	boxes_label.text = str(boxes) + "%"
	time_label.text = str(time) + " seconds"
