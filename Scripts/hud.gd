extends Node2D

@export var enemies_label: Label
@export var time_label: Label
@export var crystal_label: Label
@export var camera: Camera2D

func _ready():
	GameControl.on_pause.connect(_on_pause)
	GameControl.on_resume.connect(_on_resume)
	
func _process(_delta):
	position = camera.get_screen_center_position() - camera.get_viewport_rect().size / 2

func update(enemies: int, time: int):
	enemies_label.text = "Enemies: " + str(enemies)
	time_label.text = "Time: " + str(time)
	crystal_label.text = "x " + str(Data.crystals)

func _on_pause():
	visible = false

func _on_resume(_time: int):
	visible = true
