extends Node

signal dismissed

@export var level_label: Label
@export var boxes_label: Label
@export var time_label: Label
@export var bonus_label: Label

var _dismissed: bool = false

func _process(_delta):
	if !_dismissed and Input.is_action_just_pressed("Game Start"):
		_dismissed = true
		dismissed.emit()

func set_values(level: int, boxes: int, time: int):
	level_label.text = "Level " + str(level) + " Complete!"
	boxes_label.text = str(boxes) + "%"
	time_label.text = str(time) + " seconds"
	
	var time_mod: float = clamp(1.0 - (time - 30) / 90.0, 0.0, 1.0)
	var bonus: int = int(5 * level * time_mod)
	bonus += int(5 * level * boxes / 100.0)
	bonus_label.text = str(bonus)
	GameControl.total_crystals += bonus
	Data.crystals += bonus
	Data.save_data()
