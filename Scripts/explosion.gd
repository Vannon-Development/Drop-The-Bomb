extends Area2D

@export var fill: Node2D
@export var end: Node2D
@export var timer: float
@export var center_animation: AnimatedSprite2D

var _pieces: Array
var _first_frame: bool
var _done_time: int
var _animation_list: Array[AnimatedSprite2D]

var size

func _ready():
	for index in range(0, 4):
		_fill_dir(index)
	_first_frame = true
	_animation_list.append(center_animation)
	GameControl.on_pause.connect(_on_pause)
	GameControl.on_resume.connect(_on_resume)

func _fill_dir(dir: int):
	var placement: Vector2
	var list = Array()
	
	if dir == 0: placement = Vector2(1, 0)
	elif dir == 1: placement = Vector2(0, 1)
	elif dir == 2: placement = Vector2(-1, 0)
	else: placement = Vector2(0, -1)
	
	for index in size:
		var pos = placement * ((index + 1) * 128)
		var obj = (end if index == size - 1 else fill).duplicate()
		obj.position = pos
		obj.rotation_degrees = dir * 90
		obj.visible = true
		obj.get_children()[0].visible = false
		add_child(obj)
		list.append(obj)
		_animation_list.append(obj.get_node("Ani"))
	_pieces.append(list)
	
func _process(_delta):
	if GameControl.is_paused(): return
	if !_first_frame && Time.get_ticks_msec() >= _done_time:
		queue_free()

func _physics_process(_delta):
	if GameControl.is_paused(): return
	if _first_frame:
		_first_frame = false;
		for dir in range(0, 4):
			_test_line(dir)
		_done_time = Time.get_ticks_msec() + int(timer * 1000)
		for list in _pieces:
			for item in list:
				item.get_children()[0].visible = true

func _test_line(dir: int):
	var state = get_world_2d().direct_space_state
	var mask = 128
	var query = PhysicsRayQueryParameters2D.create(global_position, _pieces[dir].back().global_position, mask)
	query.collide_with_areas = true
	var result = state.intersect_ray(query)
	
	if result.has("collider"):
		var col = result["collider"] as CollisionObject2D
		
		# Explodable
		if col.get_collision_layer_value(9):
			col.trigger_explode()
		
		# Block
		if col.get_collision_layer_value(8):
			_break_line(dir, result["position"] - global_position)
		
func _break_line(dir: int, dist: Vector2):
	var pos: int
	if dir == 0 || dir == 2: pos = abs(int(dist.x / 128))
	else: pos = abs(int(dist.y / 128))
	
	for index in range(_pieces[dir].size() - 1, -1, -1):
		if index >= pos:
			var piece = _pieces[dir][index] as Node2D
			remove_child(piece)
			_pieces[dir].remove_at(index)

func _on_body_entered(body):
	if body.get_collision_layer_value(9):
		body.trigger_explode()

func _on_area_entered(area):
	if area.get_collision_layer_value(9):
		area.trigger_explode()

func _on_pause():
	for item in _animation_list:
		item.pause()

func _on_resume(delta: int):
	if !_first_frame:
		_done_time += delta
	for item in _animation_list:
		item.play()
