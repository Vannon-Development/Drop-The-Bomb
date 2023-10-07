extends Node

@export var crystal_label: Label

signal done

func _ready():
	crystal_label.text = "Crystals Collected: " + str(GameControl.total_crystals)
	
func _process(_delta: float):
	if Input.is_action_just_pressed("Game Start"):
		done.emit()
