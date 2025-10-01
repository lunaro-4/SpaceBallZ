extends Node

@export var move_speed : float = 0
@export var acceleration : float = 0

@export_range(0,10) var mouse_sence := 0.0

@onready var _controlled_body : PhysicsBody3D = self.get_parent()

# ДОБАВЛЯЕМ НОВЫЕ ПЕРЕМЕННЫЕ ДЛЯ ХИТБОКСА
@export var hitbox_node: NodePath  # Укажи путь к хитбоксу в инспекторе
@export var hitbox_offset_speed: float = 5.0  # Скорость перемещения хитбокса
@export var hitbox_return_speed: float = 2.0  # Скорость возврата хитбокса

var _hitbox: PhysicsBody3D = null
var _is_dragging_hitbox: bool = false
var _hitbox_target_offset: Vector3 = Vector3.ZERO
var _hitbox_current_offset: Vector3 = Vector3.ZERO
var _hitbox_initial_offset: Vector3 = Vector3.ZERO


func _ready():
	# Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	# ДОБАВЛЯЕМ ИНИЦИАЛИЗАЦИЮ ХИТБОКСА
	if hitbox_node:
		_hitbox = get_node(hitbox_node)
	if hitbox_node:
		_hitbox = get_node(hitbox_node)
		# ДОБАВЛЯЕМ СОХРАНЕНИЕ НАЧАЛЬНОГО ПОЛОЖЕНИЯ
		_hitbox_initial_offset = _hitbox.position

var _camera_direction :=  Vector2.ZERO

func _unhandled_input(_event: InputEvent) -> void:
	# var is_camera_moved := (
	# 	event is InputEventMouseMotion and
	# 	Input.mouse_mode == Input.MOUSE_MODE_CAPTURED)
	# if is_camera_moved:
	# 	_camera_direction = event.screen_relative * mouse_sence
	# pass
	
	# ДОБАВЛЯЕМ ОБРАБОТКУ ЛКМ ДЛЯ ХИТБОКСА
	if _event is InputEventMouseButton and _hitbox:
		var mouse_event = _event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT:
			_is_dragging_hitbox = mouse_event.pressed
			if not _is_dragging_hitbox:
				# При отпускании кнопки - плавный возврат
				_hitbox_target_offset = Vector3.ZERO
	
	# ДОБАВЛЯЕМ ПЕРЕМЕЩЕНИЕ ХИТБОКСА МЫШЬЮ
	if _event is InputEventMouseMotion and _is_dragging_hitbox and _hitbox:
		var mouse_event = _event as InputEventMouseMotion
		_hitbox_target_offset.x += mouse_event.relative.x * 0.01
		_hitbox_target_offset.y -= mouse_event.relative.y * 0.01
		# Ограничиваем смещение (можно настроить под себя)
		_hitbox_target_offset.x = clamp(_hitbox_target_offset.x, -2.0, 2.0)
		_hitbox_target_offset.y = clamp(_hitbox_target_offset.y, -2.0, 2.0)
	
	
	# Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	# if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
	# 	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	# else:
	# 	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	

func _process_camera_rotation(delta: float) -> void:
	_controlled_body.rotation.x -= _camera_direction.y * delta
	_controlled_body.rotation.x = clamp(_controlled_body.rotation.x, -PI/2, PI/2)
	_controlled_body.rotation.y -= _camera_direction.x * delta
	_camera_direction = Vector2.ZERO

func _process_camera_move(_delta: float) -> void:
	var movement_input := Input.get_vector("Down", "Up", "Left", "Right")
	var move_direction := Vector3(movement_input.y, movement_input.x, 0.0)
	if move_direction:
		var _kc3d := _controlled_body.move_and_collide(move_direction * move_speed)
		# if _kc3d: print(_kc3d.get_collider())

# ДОБАВЛЯЕМ НОВУЮ ФУНКЦИЮ ДЛЯ ОБНОВЛЕНИЯ ХИТБОКСА
func _process_hitbox_movement(delta: float) -> void:
	if _hitbox:
		# Плавное перемещение к целевой позиции
		_hitbox_current_offset = _hitbox_current_offset.lerp(_hitbox_target_offset, hitbox_return_speed * delta)
		
		# Устанавливаем позицию хитбокса относительно главного тела С УЧЕТОМ НАЧАЛЬНОГО СМЕЩЕНИЯ
		_hitbox.position = _hitbox_initial_offset + _hitbox_current_offset


func _physics_process(delta: float) -> void:
	# _process_camera_rotation(delta)
	_process_camera_move(delta)
	# ДОБАВЛЯЕМ ВЫЗОВ ФУНКЦИИ ХИТБОКСА
	_process_hitbox_movement(delta)
