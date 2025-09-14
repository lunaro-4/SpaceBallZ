extends Node

@export var move_speed : float = 0
@export var acceleration : float = 0

@export_range(0,10) var mouse_sence := 0.0


@onready var _controlled_body : PhysicsBody3D = self.get_parent()


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED




var _camera_direction :=  Vector2.ZERO

func _unhandled_input(event: InputEvent) -> void:
	var is_camera_moved := (
		event is InputEventMouseMotion and
		Input.mouse_mode == Input.MOUSE_MODE_CAPTURED)
	if is_camera_moved:
		_camera_direction = event.screen_relative * mouse_sence
	
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	

func _process_camera_rotation(delta: float) -> void:
	_controlled_body.rotation.x -= _camera_direction.y * delta
	_controlled_body.rotation.x = clamp(_controlled_body.rotation.x, -PI/2, PI/2)
	_controlled_body.rotation.y -= _camera_direction.x * delta
	_camera_direction = Vector2.ZERO

func _process_camera_move(_delta: float) -> void:
	var movement_input := Input.get_vector("Left", "Right", "Up", "Down")
	var forward := _controlled_body.global_basis.z
	var right := _controlled_body.global_basis.x
	var move_direction := forward * movement_input.y + right * movement_input.x
	if move_direction:
		var _kc3d := _controlled_body.move_and_collide(move_direction * move_speed)
		# if _kc3d: print(_kc3d.get_collider())


func _physics_process(delta: float) -> void:
	_process_camera_rotation(delta)
	_process_camera_move(delta)
