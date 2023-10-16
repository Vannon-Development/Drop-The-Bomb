extends StaticBody2D

@export var timer: float

signal explode

var _bomb_explode_time: int

func _ready():
	_bomb_explode_time = Time.get_ticks_msec() + int(timer * 1000)
	if Data.remote_type != 0: _bomb_explode_time += 1000 * 1000
	GameControl.on_resume.connect(_on_resume)
	
func _process(_delta):
	if GameControl.is_paused(): return
	if Time.get_ticks_msec() >= _bomb_explode_time:
		explode.emit(self)
	
func _on_player_detect_body_exited(_body):
	collision_layer += 4

func trigger_explode():
	_bomb_explode_time = 0

func _on_resume(delta: int):
	_bomb_explode_time += delta
