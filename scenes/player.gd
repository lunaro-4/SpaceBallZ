extends RigidBody3D



@onready var player_camera : Camera3D = %PlayerCamera


func _ready():
	# Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if is_multiplayer_authority():
		player_camera.make_current()
	pass


func _enter_tree() -> void:
		set_multiplayer_authority(name.to_int())

