extends RigidBody3D


@export var move_speed : float = 0
@export var acceleration : float = 0

@export_range(0,10) var mouse_sence := 0.0


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


var _camera_direction :=  Vector2.ZERO

func _unhandled_input(event: InputEvent) -> void:
	var is_camera_moved := (
		event is InputEventMouseMotion and
		Input.mouse_mode == Input.MOUSE_MODE_CAPTURED)

	if is_camera_moved:
		_camera_direction = event.screen_relative * mouse_sence

func _process_camera_rotation(delta: float) -> void:
	self.rotation.x -= _camera_direction.y * delta
	self.rotation.x = clamp(self.rotation.x, -PI/2, PI/2)
	self.rotation.y -= _camera_direction.x * delta
	_camera_direction = Vector2.ZERO

func _process_camera_move(delta: float) -> void:
	var movement_input := Input.get_vector("Left", "Right", "Up", "Down")
	var forward := self.global_basis.z
	var right := self.global_basis.x
	var move_direction := forward * movement_input.y + right * movement_input.x
	linear_velocity = linear_velocity.move_toward(move_direction * move_speed, acceleration * delta)


func _physics_process(delta: float) -> void:
	_process_camera_rotation(delta)
	_process_camera_move(delta)
