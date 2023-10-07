extends CharacterBody2D

signal position_changed
signal drop_bomb
signal game_lost

@export var walk_speed: float
@export var visuals: Array[Node2D]
@export var death: AnimatedSprite2D

const _tile_size: int = 128

enum motions { left, right, up, down, walk_left, walk_right, walk_up, walk_down }

var _direction: motions
var _saved_walk_speed: float
var _dead: bool = false

func _ready():
	var startPos = _tile_size * 1.5
	position = Vector2(startPos, startPos)
	_direction = motions.right
	_saved_walk_speed = walk_speed * (1 + (Data.walk_speed - 1) * 0.2)
	GameControl.on_pause.connect(_on_pause)
	GameControl.on_resume.connect(_on_resume)

func _physics_process(_delta):
	if GameControl.is_paused() || _dead: return
	
	var motion: Vector2 = Vector2(0, 0)
	_set_direction(_direction, false)
	if Input.is_action_pressed("Left"):
		motion.x -= _tile_size * _saved_walk_speed
		_set_direction(motions.left, true)
	if Input.is_action_pressed("Right"):
		motion.x += _tile_size * _saved_walk_speed
		_set_direction(motions.right, true)
	if Input.is_action_pressed("Up"):
		motion.y -= _tile_size * _saved_walk_speed
		_set_direction(motions.up, true)
	if Input.is_action_pressed("Down"):
		motion.y += _tile_size * _saved_walk_speed
		_set_direction(motions.down, true)
	if Input.is_action_just_pressed("Bomb"):
		drop_bomb.emit()
		
	_set_visual(_direction)
	velocity = motion
	move_and_slide()
	for index in get_slide_collision_count():
		var col = get_slide_collision(index)
		if col.get_collider().get_collision_layer_value(6):
			_on_enemy_hit()
	position_changed.emit(position)

func _set_visual(val: motions):
	for item in motions.keys().size():
		visuals[item].visible = false
	visuals[val].visible = true
	if visuals[val] is AnimatedSprite2D:
		(visuals[val] as AnimatedSprite2D).play()
	
func _set_direction(dir: motions, moving: bool):
	if dir == motions.left || dir == motions.walk_left: _direction = motions.walk_left if moving else motions.left
	elif dir == motions.right || dir == motions.walk_right: _direction = motions.walk_right if moving else motions.right
	elif dir == motions.down || dir == motions.walk_down: _direction = motions.walk_down if moving else motions.down
	elif dir == motions.up || dir == motions.walk_up: _direction = motions.walk_up if moving else motions.up

func _on_bomb_hit():
	_die()
	
func _on_enemy_hit():
	_die()

func _on_pause():
	if _direction > motions.down:
		visuals[_direction].pause()

func _on_resume():
	if _direction > motions.down:
		visuals[_direction].play()

func _die():
	if not _dead:
		_dead = true
		for item in visuals:
			item.visible = false
		death.visible = true
		death.animation_finished.connect(_die_done)
		death.play()
		
func _die_done():
	GameControl.pause()
	game_lost.emit()
