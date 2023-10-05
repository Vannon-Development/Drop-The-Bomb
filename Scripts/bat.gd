extends CharacterBody2D

signal drop_crystal(pos: Vector2, amount: int)
signal dead

@export var sprite: AnimatedSprite2D
@export var explode: AnimatedSprite2D
@export var speed: float

var _direction = Vector2(0, 0)
var _last_pos: Vector2
var _change_direction_time: int
var _exploding: bool = false

func _ready():
	_last_pos = position
	explode.visible = false
	GameControl.on_pause.connect(_on_pause)
	GameControl.on_resume.connect(_on_resume)

func _physics_process(_delta):
	if GameControl.is_paused(): return
	if _exploding: return
	if (position - _last_pos).is_zero_approx() || Time.get_ticks_msec() >= _change_direction_time:
		_direction = _choose_direction()
		_change_direction_time = Time.get_ticks_msec() + int(3 / speed * 1000)
	velocity = _direction * speed * 128
	_last_pos = position
	move_and_slide()

func _choose_direction():
	var directions = [Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]
	var state = get_world_2d().direct_space_state
	var good_list = []
	for direction in directions:
		var query = PhysicsRayQueryParameters2D.create(global_position, global_position + direction * (128 * 2), collision_mask)
		var result = state.intersect_ray(query)
		if !result: good_list.append(direction)
		else:
			var diff = (global_position - result["position"]).length()
			if diff > 80: good_list.append(direction)
	if good_list.size() == 0: return Vector2(0, 0)
	return good_list[randi_range(0, good_list.size() - 1)]

func trigger_explode():
	if _exploding: return 
	_exploding = true
	sprite.visible = false
	explode.visible = true
	explode.animation_finished.connect(_explode_done)
	explode.play()
	dead.emit(self)

func _explode_done():
	drop_crystal.emit(position, 1)
	queue_free()
	
func _on_pause():
	if _exploding: explode.pause()
	else: sprite.pause()

func _on_resume():
	if _exploding: explode.play()
	else: sprite.play()
