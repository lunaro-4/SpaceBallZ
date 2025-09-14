extends RigidBody3D




func _ready():
	linear_velocity = Vector3(1.0, 0.0, 0.0)

func _physics_process(delta: float) -> void:

	linear_velocity *=1.000001

	var collision = move_and_collide(linear_velocity * delta)
	if collision:
		linear_velocity = linear_velocity.bounce(collision.get_normal()) * 1
