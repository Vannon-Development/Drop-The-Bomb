extends CharacterBody2D

signal drop_crystal(pos: Vector2, amount: int)
signal dead

@export var sprite: AnimatedSprite2D
@export var fire_sprite: AnimatedSprite2D
@export var explode: AnimatedSprite2D
@export var speed: float
@export var fire_speed: float

var _direction: Vector2 = Vector2(0, 0)
var _last_pos: Vector2
var _change_direction_time: int
var _exploding: bool = false
var _on_fire: bool = false
var _immune_time: int

func _ready():
	_last_pos = position
	explode.visible = false
	fire_sprite.visible = false
	GameControl.on_pause.connect(_on_pause)
	GameControl.on_resume.connect(_on_resume)

func _physics_process(_delta):
	if GameControl.is_paused(): return
	if _exploding: return
	if (position - _last_pos).is_zero_approx() || Time.get_ticks_msec() >= _change_direction_time:
		_direction = _choose_direction()
		_change_direction_time = Time.get_ticks_msec() + int(3 / speed * 1000)
	var s = fire_speed if _on_fire else speed
	velocity = _direction * (s * 128)
	_last_pos = position
	move_and_slide()

func _choose_direction() -> Vector2:
	var directions: Array[Vector2] = [Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]
	var state = get_world_2d().direct_space_state
	var good_list: Array[Vector2] = []
	for direction in directions:
		var query := PhysicsRayQueryParameters2D.create(global_position, global_position + direction * (128 * 2), collision_mask)
		var result = state.intersect_ray(query)
		if !result: good_list.append(direction)
		else:
			var diff: float = (global_position - result["position"]).length()
			if diff > 80: good_list.append(direction)
	if good_list.size() == 0: return Vector2(0, 0)
	return good_list[randi_range(0, good_list.size() - 1)]

func trigger_explode():
	if _exploding: return
	
	if _on_fire && Time.get_ticks_msec() > _immune_time:
		_exploding = true
		sprite.visible = false
		fire_sprite.visible = false
		explode.visible = true
		explode.animation_finished.connect(_explode_done)
		explode.play()
		dead.emit(self)
	else:
		sprite.visible = false
		fire_sprite.visible = true
		fire_sprite.play()
		_immune_time = Time.get_ticks_msec() + 750
		_on_fire = true

func _explode_done():
	drop_crystal.emit(position, 3)
	queue_free()
	
func _on_pause():
	if _exploding: explode.pause()
	elif _on_fire: fire_sprite.pause()
	else: sprite.pause()

func _on_resume(delta: int):
	if _exploding: explode.play()
	elif _on_fire: 
		fire_sprite.pause()
		_immune_time += delta
	else: sprite.play()
